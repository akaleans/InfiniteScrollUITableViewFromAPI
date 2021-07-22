//
//  EventCell.swift
//  SeatGeekUITableView
//
//  Created by Khalen Stensby on 7/16/21.
//

import UIKit

class EventCell: UITableViewCell {
    
    var eventImageView = UIImageView()
    var eventTitleLabel = UILabel()
    var eventLocationLabel = UILabel()
    var eventDateLabel = UILabel()
    var id: Int = -1

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(eventImageView)
        addSubview(eventTitleLabel)
        addSubview(eventLocationLabel)
        addSubview(eventDateLabel)
        
        configureImageView()
        configureTitleLabel()
        configureLocationLabel()
        configureDateLabel()
        
        setImageConstraints()
        setTitleLabelConstraints()
        setDateLabelConstraints()
        setLocationLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(event: Event){
        eventImageView.image = event.image
        eventTitleLabel.text = event.title
        eventLocationLabel.text = event.location
        eventDateLabel.text = event.date
    }
    
    func configureImageView() {
        eventImageView.layer.cornerRadius = 10
        eventImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        let font: UIFont = UIFont.boldSystemFont(ofSize: 20)
        eventTitleLabel.numberOfLines = 0
        eventTitleLabel.adjustsFontSizeToFitWidth = true
        eventTitleLabel.font = font
    }
    
    func configureLocationLabel() {
        eventLocationLabel.numberOfLines = 0
        eventLocationLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureDateLabel() {
        eventDateLabel.numberOfLines = 0
        eventDateLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints(){
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        eventImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        eventImageView.widthAnchor.constraint(equalTo: eventImageView.heightAnchor, multiplier: 4/3).isActive = true
    }
    
    func setTitleLabelConstraints() {
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        eventTitleLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 20).isActive = true
        eventTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        eventTitleLabel.bottomAnchor.constraint(equalTo: eventLocationLabel.topAnchor, constant: 5).isActive = true
        eventTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    func setLocationLabelConstraints() {
        eventLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        eventLocationLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 20).isActive = true
        eventLocationLabel.bottomAnchor.constraint(equalTo: eventDateLabel.topAnchor, constant: -5).isActive = true
        eventLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    func setDateLabelConstraints() {
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDateLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 20).isActive = true
        eventDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        eventDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
}
