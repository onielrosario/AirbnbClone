//
//  RaceReview.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
import CoreLocation

struct UserProfile {
  let name: String
  let email: String
    let imageurl: String
  let lat: Double
  let lon: Double
  let userId: String
  let dbReferenceDocumentId: String // reference to the race review document, useful for e.g deleting
  
    init(name: String, email: String,imageurl: String, lat: Double, lon: Double, userId: String, dbReference: String) {
    self.name = name
    self.email = email
        self.imageurl = imageurl
    self.lat = lat
    self.lon = lon
    self.userId = userId
    self.dbReferenceDocumentId = dbReference
  }
  
  init(dict: [String: Any]) {
    self.name = dict["username"] as? String ?? "no user name"
    self.email = dict["email"] as? String ?? "no user email"
    self.imageurl = dict["imageURL"] as? String ?? "no photo url"
    self.lat = dict["latitude"] as? Double ?? 0
    self.lon = dict["longitude"] as? Double ?? 0
    self.userId = dict["userId"] as? String ?? "no user Id"
    self.dbReferenceDocumentId = dict["dbReference"] as? String ?? "no dbReference"
  }
  
  // computed property to return a coordinate from the given lat and lon properties
  public var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(lat, lon)
  }
}
