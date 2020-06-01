//
//  LocationManager.swift
//  FoodFinder
//
//  Created by Sujan Kanna on 6/1/20.
//  Copyright © 2020 Exercise. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation
import RxOptional

class LocationManager {
    static let shared = LocationManager()
    var locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    private init() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        setupBindings()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    private func setupBindings() {
        locationManager.rx.didUpdateLocations
            .map { $0.locations.last?.coordinate }
            .filterNil()
            .distinctUntilChanged { $0.latitude == $1.latitude && $0.longitude == $1.longitude }
            .subscribe(onNext: { [weak self] coordinate in
                self?.locationCoordinate = coordinate
            })
            .disposed(by: disposeBag)
    }
    
}

