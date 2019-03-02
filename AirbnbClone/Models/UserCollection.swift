//
//  UserCollection.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 3/1/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import Foundation
import CoreLocation



struct UserCollection {
    let title: String
    let rooms: Int
    let price: Double
    let address: String
    let lat: Double
    let long: Double
    let description: String
    let startDate: String
    let endDate: String
    let userID: String
    let documentID: String
    
    init(title: String, rooms: Int, price: Double, address: String, lat: Double, long: Double, description: String, startDate: String, endDate: String, userID: String, documentID: String) {
        self.title = title
        self.rooms = rooms
        self.price = price
        self.address = address
        self.lat = lat
        self.long = long
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.userID = userID
        self.documentID = documentID
    }
    
    init(dict: [String:Any]) {
        self.title = dict["title"] as? String ?? "no title"
        self.rooms = dict["rooms"] as? Int ?? 0
        self.price = dict["price"] as? Double ?? 0.0
        self.address = dict["address"] as? String ?? "no address"
        self.lat = dict["lat"] as? Double ?? 0.0
        self.long = dict["long"] as? Double ?? 0.0
        self.description = dict["description"] as? String ?? "no description"
        self.startDate = dict["startDate"] as? String ?? "no start date"
        self.endDate = dict["endDate"] as? String ?? "no end date"
        self.userID = dict["userID"] as? String ?? "no user"
        self.documentID = dict["documentID"] as? String ?? "no user documents"
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

