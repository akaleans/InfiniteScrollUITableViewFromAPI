//
//  EventsListViewController.swift
//  SeatGeekUITableView
//
//  Created by Khalen Stensby on 7/16/21.
//

import UIKit
import CoreLocation

class EventsListViewController: UIViewController, CLLocationManagerDelegate {
    
    let db = DBHelper()
    var tableView = UITableView()
    var events: [Event] = []
    var filteredEvents: [Event] = []
    var locationManager = CLLocationManager()
    var lat: Double = 0.0
    var lon: Double = 0.0
    var page: Int = 1
    var loading: Bool = false
    var initialLoad: Bool = false
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        s.obscuresBackgroundDuringPresentation = false
        s.searchBar.placeholder = "Search Events"
        s.searchBar.sizeToFit()
        s.searchBar.searchBarStyle = .prominent
        s.searchBar.delegate = self
        
        return s
    }()
    
    struct Cells {
        static let eventCell = "EventCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        getLocationEvents()
    }
    
    func getLocationEvents() {
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location)
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            consumeNextPage()
        }
    }
    
    func configTableView(){
        if (initialLoad){
            self.tableView.reloadData()
        }
        else {
            view.addSubview(tableView)
            setDelegates()
            tableView.rowHeight = 150
            tableView.register(EventCell.self, forCellReuseIdentifier: Cells.eventCell)
            tableView.pin(to: view)
            initialLoad = true
        }
    }
    
    func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        if distanceFromBottom <= height {
            consumeNextPage()
        }
    }
    
    func consumeNextPage() {
        
        if !canLoadMoreEvents(loading: loading){
            return
        }
        loading = true
        
        let url = URL(string : "https://api.seatgeek.com/2/events?client_id=MjI1NTU1MDB8MTYyNjQ4NDIyNy41MTg2NzU2&client_secret=ccc0172baeb4a12338cd317e6163c116312f333eb03a7800ef8d20d4fbfbb41d&lat=\(lat)&lon=\(lon)&page=\(page)")!
        let datatask = URLSession.shared.dataTask(with: url, completionHandler: parsePageFromResponse(data:response:error:))
        datatask.resume()
    }
    
    func parsePageFromResponse(data: Data?, response: URLResponse?, error: Error?){
        guard error == nil else {
            print("Error: \(String(describing: error))")
            loading = false
            return
        }
        guard let data = data else {
            print("No data")
            loading = false
            return
        }
        
        let newEvents = parseEventsFromData(data: data)
        DispatchQueue.main.async {
            self.events.append(contentsOf: newEvents)
            self.configTableView()
            self.filterEventsBySearch(searchText: self.searchController.searchBar.text!)
            self.page += 1
            self.loading = false
        }
    }
    
    func parseEventsFromData(data: Data) -> [Event] {
        let eventsData = try! JSONDecoder().decode(EventDataList.self, from: data)
        
        var events: [Event] = []
        
        for e in eventsData.events! {
            
            var date = ""
            if !e.datetime_tbd! {
                date = formatDate(date: e.datetime_local!)
            }
            else {
                date = "TBD"
            }
            
            events.append(Event(image: UIImage(data: try! Data(contentsOf: URL(string: e.performers![0].image!)!))!, title: e.title!, location: "\(e.venue!.city!),  \(e.venue!.state!)", date: date, id: e.id!, type: e.type!))
        }
        return events
    }
    
    func filterEventsBySearch(searchText: String) {
        filteredEvents = events.filter({ (event: Event) -> Bool in
            return event.location.lowercased().contains(searchText.lowercased()) ||
                event.title.lowercased().contains(searchText.lowercased()) ||
                event.type.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltered() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }
    
}

extension EventsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered() { return filteredEvents.count }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.eventCell) as! EventCell
        
        let favorites = db.getFavorites()
        
        let currentEvent: Event
        
        if isFiltered() {
            currentEvent = filteredEvents[indexPath.row]
        }
        else {
            currentEvent = events[indexPath.row]
        }
        
        if favorites.contains(where: { $0.id == currentEvent.id }) == false {
            cell.favoriteImage.removeFromSuperview()
        }
        
        cell.set(event: currentEvent)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailsView = EventDetailsViewController()
        if isSearchBarEmpty(){
            eventDetailsView.event = events[indexPath.row]
        }
        else {
            eventDetailsView.event = filteredEvents[indexPath.row]
        }
        eventDetailsView.hidesBottomBarWhenPushed = true
        eventDetailsView.db = db
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.navigationController?.pushViewController(eventDetailsView, animated: true)
    }
    
}

extension EventsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterEventsBySearch(searchText: searchBar.text!)
    }
    
}

extension EventsListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterEventsBySearch(searchText: searchController.searchBar.text!)
    }
    
}
