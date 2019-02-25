//
//  DatabaseManager.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DatabaseManager {
  
  private init() {}
  
  static let firebaseDB: Firestore = {
    // gets a reference to firestore database
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    
    return db
  }()
  
  static func postUserToDatabase(userInfo: UserProfile) {
    var ref: DocumentReference? = nil
    ref = firebaseDB.collection(DatabaseKeys.RaceReviewCollectionKey).addDocument(data: [
                                                                  "username"    : userInfo.name,
                                                                  "email"  : userInfo.email,
                                                                  "password"  : userInfo.password,
                                                                  "latitude"    : userInfo.lat,
                                                                  "longitude"   : userInfo.lon,
                                                                  "userID"    : userInfo.userId
      ], completion: { (error) in
      if let error = error {
        print("posting user failed with error: \(error)")
      } else {
        print("user created at ref: \(ref?.documentID ?? "no doc id")")
        // updating a firestore dcoument:
        // here we are updating the field dbReference for race review,
        // useful for e.g deleting a (race review) document
        DatabaseManager.firebaseDB.collection(DatabaseKeys.RaceReviewCollectionKey)
          .document(ref!.documentID)
          .updateData(["dbReference": ref!.documentID], completion: { (error) in
          if let error = error {
            print("error updating field: \(error)")
          } else {
            print("field updated")
          }
        })
      }
    })
  }
}
