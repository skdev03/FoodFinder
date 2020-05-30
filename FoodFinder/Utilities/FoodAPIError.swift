//
//  FoodAPIError.swift
//  FoodFinder
//
//  Created by Sujan Kanna on 5/29/20.
//  Copyright © 2020 Exercise. All rights reserved.
//

import Foundation

enum FoodAPIError: Error {
    case parsing(description: String)
    case network(description: String)
}
