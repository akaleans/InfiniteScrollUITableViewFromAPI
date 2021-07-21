//
//  EventData.swift
//  SeatGeekUITableView
//
//  Created by Khalen Stensby on 7/17/21.
//

import Foundation

struct EventData : Codable {
    
    var title: String?
    var url: String?
    var type: String?
    var performers: [PerformerData]?
    var venue: VenueData?
    var datetime_local: String?
    var datetime_tbd: Bool?
    var id: Int?
    
}
