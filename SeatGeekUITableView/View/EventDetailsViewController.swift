//
//  EventDetailsViewController.swift
//  SeatGeekUITableView
//
//  Created by Khalen Stensby on 7/21/21.
//

import UIKit

class EventDetailsViewController: UIViewController {

    var db: DBHelper? = nil
    var favorites: [Favorite]? = nil
    let contentView = UIView()
    var event: Event? = nil
    var isFavorite: Bool? = nil
    var favoriteButton: UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favorites = db!.getFavorites()
        view.backgroundColor = .white
        configureContentView()
        setViews()
    }

    func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setViews() {
        let eventImage = setImage()
        let eventTitle = setTitle()
        let eventLocation = setLocation()
        let eventDate = setDate()
        favoriteButton = setFavoriteButton()
        
        contentView.addSubview(eventImage)
        contentView.addSubview(eventTitle)
        contentView.addSubview(eventLocation)
        contentView.addSubview(eventDate)
        contentView.addSubview(favoriteButton!)
        
        eventImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        eventImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        eventImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        eventImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        eventImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        eventTitle.topAnchor.constraint(equalTo: eventImage.bottomAnchor, constant: 15).isActive = true
        eventTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        eventTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        eventDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        eventDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        eventDate.topAnchor.constraint(equalTo: eventLocation.bottomAnchor, constant: 15).isActive = true
        
        eventLocation.topAnchor.constraint(equalTo: eventTitle.bottomAnchor, constant: 15).isActive = true
        eventLocation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        eventLocation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        favoriteButton!.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        favoriteButton!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -45).isActive = true
        
    }
    
    func setImage() -> UIImageView {
        let eventImage = UIImageView()
        eventImage.image = event?.image
        eventImage.contentMode = .scaleAspectFill
        eventImage.clipsToBounds = true
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        eventImage.layer.cornerRadius = 10
        eventImage.clipsToBounds = true
        return eventImage
    }
    
    func setTitle() -> UILabel {
        let title = UILabel()
        title.numberOfLines = 0
        title.text = event?.title
        title.font = .systemFont(ofSize: 32, weight: .heavy)
        title.sizeToFit()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }
    
    func setLocation() -> UILabel {
        let location = UILabel()
        location.numberOfLines = 0
        location.text = event?.location
        location.font = .systemFont(ofSize: 24)
        location.textColor = UIColor.gray
        location.sizeToFit()
        location.translatesAutoresizingMaskIntoConstraints = false
        return location
    }
    
    func setDate() -> UILabel {
        let date = UILabel()
        date.numberOfLines = 0
        date.text = event?.date
        date.font = .systemFont(ofSize: 24)
        date.textColor = UIColor.gray
        date.sizeToFit()
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }
    
    func setFavoriteButton() -> UIButton {
        let favoriteButton = UIButton.init(type: .system)
        if (favorites?.contains(where: { $0.id == event?.id }) == true) {
            favoriteButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            isFavorite = true
        }
        else {
            favoriteButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            isFavorite = false
        }
        favoriteButton.tintColor = .systemPink
        favoriteButton.addTarget(self, action: #selector(favorite(_:)), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        return favoriteButton
    }
    
    @objc func favorite(_ sender: UIButton!){
        if isFavorite! {
            db!.delete(id: event!.id)
            favoriteButton!.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            isFavorite = false
        }
        else {
            db!.insert(id: event!.id)
            favoriteButton!.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            isFavorite = true
        }
    }

}
