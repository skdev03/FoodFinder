//
//  BusinessCell.swift
//  FoodFinder
//
//  Created by Sujan Kanna on 5/29/20.
//  Copyright © 2020 Exercise. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
    static var identifier: String { get }
}

class BusinessCell: UITableViewCell, CellIdentifiable {
    
    @IBOutlet private weak var businessImageView: UIImageView!
    @IBOutlet private weak var businessNameLabel: UILabel!
    @IBOutlet private weak var businessAliasLabel: UILabel!
    
    static var identifier: String {
        return "BusinessCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        businessImageView.image = nil
    }
    
    func update(business: Business) {
        businessNameLabel.text = business.name
        businessAliasLabel.text = business.alias
        
        if let url = URL(string: business.image_url) {
            let placeholderImage = UIImage(named: "PlaceholderImage")
            businessImageView.loadImage(from: url, placeholder: placeholderImage)
        }
    }
}
