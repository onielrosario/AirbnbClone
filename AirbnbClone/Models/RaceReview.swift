//
//  RaceReview.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
import CoreLocation

struct RaceReview {
  let name: String
  let review: String
  let type: String
  let lat: Double
  let lon: Double
  let reviewerId: String
  let dbReferenceDocumentId: String // reference to the race review document, useful for e.g deleting
  
  init(name: String, review: String, type: String, lat: Double, lon: Double, reviewerId: String, dbReference: String) {
    self.name = name
    self.review = review
    self.type = type
    self.lat = lat
    self.lon = lon
    self.reviewerId = reviewerId
    self.dbReferenceDocumentId = dbReference
  }
  
  init(dict: [String: Any]) {
    self.name = dict["raceName"] as? String ?? "no race name"
    self.review = dict["raceReview"] as? String ?? "no race review"
    self.type = dict["raceType"] as? String ?? "other"
    self.lat = dict["latitude"] as? Double ?? 0
    self.lon = dict["longitude"] as? Double ?? 0
    self.reviewerId = dict["reviewerId"] as? String ?? "no reviewerId"
    self.dbReferenceDocumentId = dict["dbReference"] as? String ?? "no dbReference"
  }
  
  // computed property to return a coordinate from the given lat and lon properties
  public var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(lat, lon)
  }
}
