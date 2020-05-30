//
//  SearchViewModel.swift
//  FoodFinder
//
//  Created by Sujan Kanna on 5/29/20.
//  Copyright © 2020 Exercise. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class LocationManager {
    static let shared = LocationManager()
    
    var locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
}

class SearchViewModel {
    private let service: BusinessSearchable
    private let disposeBag = DisposeBag()
    let businessesObservable: Observable<Event<[Business]>>
    let businesses: Observable<[Business]>
    let errors: Observable<FoodAPIError>
    var locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    init(service: BusinessSearchable, searchBarObservable: Observable<String>) {
        self.service = service
        
        businessesObservable = searchBarObservable.flatMap { (searchTerm) -> Observable<Event<[Business]>> in
            return service.businesses(forLat: "\(LocationManager.shared.locationCoordinate.latitude)", lng: "\(LocationManager.shared.locationCoordinate.longitude)", searchTerm: searchTerm)
                .observeOn(MainScheduler.instance)
                .materialize()
            
        }.share()
        
        businesses = businessesObservable
            .map { $0.element }
            .filter { $0 != nil }
            .map { $0! }

        errors = businessesObservable
            .map { $0.error as? FoodAPIError }
            .filter { $0 != nil }
            .map { $0! }
    }

}
