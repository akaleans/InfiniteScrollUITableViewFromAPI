//
//  EventsListViewController.swift
//  SeatGeekUITableView
//
//  Created by Khalen Stensby on 7/16/21.
//

import UIKit

class EventsListViewController: UIViewController {
    
    var tableView = UITableView()
    var events: [Event] = []
    
    struct Cells {
        static let eventCell = "EventCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Events"
        fetchEventsData { (events) in
            self.events = events
            DispatchQueue.main.async {
                self.configTableView()
            }
        }
    }

    func configTableView(){
        view.addSubview(tableView)
        setDelegates()
        tableView.rowHeight = 150
        tableView.register(EventCell.self, forCellReuseIdentifier: Cells.eventCell)
        tableView.pin(to: view)
    }
    
    func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchEventsData(completionHandler: @escaping ([Event]) -> Void){
        
        let url = URL(string : "https://api.seatgeek.com/2/events?client_id=MjI1NTU1MDB8MTYyNjQ4NDIyNy41MTg2NzU2&client_secret=ccc0172baeb4a12338cd317e6163c116312f333eb03a7800ef8d20d4fbfbb41d")!
        
        let datatask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }

            do {
                let eventsData = try JSONDecoder().decode(EventDataList.self, from: data)
                
                var events: [Event] = []
                
                for e in eventsData.events! {
                    
                    var date = ""
                    if !e.datetime_tbd! {
                        date = self.formatDate(date: e.datetime_local!)
                    }
                    else {
                        date = "TBD"
                    }
                    
                    events.append(Event(image: UIImage(data: try Data(contentsOf: URL(string: e.performers![0].image!)!))!, title: e.title!, location: "\(e.venue!.city!),  \(e.venue!.state!)", date: date))
                }
                completionHandler(events)
            }
            catch {
                let e = error
                print(e.localizedDescription)
            }
        }.resume()
    }
    
    func formatDate(date: String) -> String {
        
        var d = date.replacingOccurrences(of: "T", with: " ")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateObj = dateFormatter.date(from: d) {
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm a"
            d = dateFormatter.string(from: dateObj)
        }
        return d
        
    }
    
}

extension EventsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.eventCell) as! EventCell
        let event = events[indexPath.row]
        cell.set(event: event)
        
        return cell
    }
    
}
