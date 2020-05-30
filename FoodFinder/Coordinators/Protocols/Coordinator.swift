//
//  Coordinator.swift
//  FoodFinder
//
//  Created by Sujan Kanna on 5/29/20.
//  Copyright © 2020 Exercise. All rights reserved.
//

import UIKit
import Foundation

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}
