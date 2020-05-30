//
//  BusinessSearchService.swift
//  FoodFinder
//
//  Created by Sujan Kanna on 5/29/20.
//  Copyright © 2020 Exercise. All rights reserved.
//

import Foundation
import RxSwift

protocol BusinessSearchable {
    func businesses(forLat lat: String, lng: String, searchTerm: String) -> Observable<[Business]>
}

class BusinessSearchService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension BusinessSearchService: BusinessSearchable {
    func businesses(forLat lat: String, lng: String, searchTerm: String) -> Observable<[Business]> {
        return Observable.create { observer -> Disposable in
            let urlComponents = self.makeBusinessSearchComponents(searchTerm: searchTerm, lat: lat, lng: lng)
            
            if let url = urlComponents.url {
                var urlRequest = URLRequest(url: url)
                urlRequest.setValue("Bearer \(BusinessSearchAPI.APIKey)", forHTTPHeaderField: "Authorization")
                self.session.dataTask(with: urlRequest) { (data, response, error) in
                    if let data = data {
                        do {
                            let root = try JSONDecoder().decode(MainResponse.self, from: data)
                            observer.onNext(root.businesses)
                        } catch let parsingError {
                            let error = FoodAPIError.parsing(description: parsingError.localizedDescription)
                            observer.onError(error)
                        }
                    } else {
                        if let error = error {
                            let error = FoodAPIError.network(description: error.localizedDescription)
                            observer.onError(error)
                        } else {
                            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                            let error = FoodAPIError.network(description: "Failed with status code: \(statusCode)")
                            observer.onError(error)
                        }
                    }
                }.resume()
            } else {
                let error = FoodAPIError.network(description: "Could not create URL")
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
}

// https://api.yelp.com/v3/businesses/search
// Client ID
//FNoh4Py1HiGlpvxJlrR5mw

//API Key
//Lb0ulqq_UoSNdWR9M2pV0PydkPA7gSIhNgWz8ds3Kfv9Vt0QA0wXkvykCnLzQwRG2QTEFEUiRotAUgjwlbut6NGLDicUTivQKi4Br3f9s8CLyRAhZXwFPO9HUYrRXnYx
extension BusinessSearchService {
    struct BusinessSearchAPI {
        static let scheme = "https"
        static let host = "api.yelp.com"
        static let path = "/v3/businesses/search"
        static let APIKey = "Lb0ulqq_UoSNdWR9M2pV0PydkPA7gSIhNgWz8ds3Kfv9Vt0QA0wXkvykCnLzQwRG2QTEFEUiRotAUgjwlbut6NGLDicUTivQKi4Br3f9s8CLyRAhZXwFPO9HUYrRXnYx"
    }
    
    func makeBusinessSearchComponents(searchTerm: String, lat: String, lng: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = BusinessSearchAPI.scheme
        components.host = BusinessSearchAPI.host
        components.path = BusinessSearchAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "term", value: searchTerm),
            URLQueryItem(name: "latitude", value: lat),
            URLQueryItem(name: "longitude", value: lng),
            URLQueryItem(name: "limit", value: "20")
        ]
        
        return components
    }
}
