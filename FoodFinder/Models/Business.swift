//
//  Business.swift
//  FoodFinder
//
//  Created by Sujan Kanna on 5/29/20.
//  Copyright © 2020 Exercise. All rights reserved.
//

import Foundation

struct MainResponse: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let name: String
    let url: String
    let image_url: String
    let alias: String
}
