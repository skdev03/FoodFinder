//
//  SearchViewController.swift
//  FoodFinder
//
//  Created by Sujan Kanna on 5/29/20.
//  Copyright © 2020 Exercise. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class SearchViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()
    private var businesses: [Business] = []
    //Location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchViewController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchViewController
        viewModel = SearchViewModel(service: BusinessSearchService(), searchBarObservable: searchViewController.searchBar.rx.text.orEmpty.asObservable())
        setupView()
        setupBindings()
        setupLocationAccess()
    }

    private func setupLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    private func setupView() {
        title = "Restaurants"
        let nib = UINib(nibName: "BusinessCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BusinessCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel.businesses.subscribe(onNext: { (businesses) in
            self.businesses = businesses
            self.tableView.reloadData()
        })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCell.identifier, for: indexPath) as? BusinessCell else {
            return UITableViewCell()
        }
        
        cell.update(business: businesses[indexPath.row])
        return cell
    }
    
    
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        LocationManager.shared.locationCoordinate = locValue
        locationManager.stopUpdatingLocation()
    }
}

