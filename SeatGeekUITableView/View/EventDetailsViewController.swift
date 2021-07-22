//
//  EventDetailsViewController.swift
//  SeatGeekUITableView
//
//  Created by Khalen Stensby on 7/21/21.
//

import UIKit

class EventDetailsViewController: UIViewController {

    let contentView = UIView()
    var event: Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureContentView()
        setViews()
    }

    func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setViews() {
        contentView.addSubview(setImage())
    }
    
    func setImage() -> UIImageView{
        let eventImage = UIImageView()
        eventImage.image = event?.image
        eventImage.contentMode = .scaleAspectFill
        eventImage.clipsToBounds = true
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        return eventImage
    }

}
