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

class SearchViewModel {
    private let service: BusinessSearchable
    private let disposeBag = DisposeBag()
    let businessesObservable: Observable<Event<[Business]>>
    let businesses: Observable<[Business]>
    let errors: Observable<FoodAPIError>
    
    init(service: BusinessSearchable, searchBarObservable: Observable<String>) {
        self.service = service
        
        businessesObservable = searchBarObservable.flatMapLatest { (searchTerm) -> Observable<Event<[Business]>> in
            return service.businesses(forLat: "\(LocationManager.shared.locationCoordinate.latitude)", lng: "\(LocationManager.shared.locationCoordinate.longitude)", searchTerm: searchTerm)
                .observeOn(MainScheduler.instance)
                .materialize()
        }
        
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
