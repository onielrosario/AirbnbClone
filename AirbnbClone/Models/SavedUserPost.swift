//
//  SavedUserPost.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 3/7/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import Foundation


struct SavePostModel: Codable {
    let id: String
    let title: String
    let location: String
    let image: String
}
