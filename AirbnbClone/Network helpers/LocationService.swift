//
//  LocationService.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/15/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationService {
  
  static public func getCoordinate( addressString : String,
                      completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressString) { (placemarks, error) in
      if error == nil {
        if let placemark = placemarks?[0] {
          let location = placemark.location!
          completionHandler(location.coordinate, nil)
          return
        }
      }
      completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
    }
  }
}
