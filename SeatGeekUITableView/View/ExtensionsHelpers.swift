//
//  Extensions.swift
//  SeatGeekUITableView
//
//  Created by Khalen Stensby on 7/16/21.
//

import UIKit

extension UIView {
    
    func pin(to superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}

func canLoadMoreEvents(loading: Bool) -> Bool {
    if loading {
        return false
    }
    return true
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
