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

class SearchViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()
    private var businesses: [Business] = []
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.start()
        viewModel = SearchViewModel(service: BusinessSearchService(), searchBarObservable: searchBar.rx.text.orEmpty.asObservable())
        setupView()
        setupBindings()
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

// MARK:- Helpers
extension SearchViewController {
    private func setupView() {
        navigationItem.titleView = searchBar
        setupTableView()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "BusinessCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BusinessCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel.businesses
            .subscribe(onNext: { (businesses) in
                self.businesses = businesses
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
