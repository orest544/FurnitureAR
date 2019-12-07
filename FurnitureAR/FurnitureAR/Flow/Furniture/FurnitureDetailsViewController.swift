//
//  FurnitureDetailsViewController.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 07.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

class FurnitureDetailsViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: LoadingImageView!
    @IBOutlet private weak var tryWithAugmentedRealityButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var selectedFurniture: Furniture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    private func configureSubviews() {
        if let furniture = selectedFurniture {
            fillInfo(with: furniture)
        }
        tryWithAugmentedRealityButton.layer.cornerRadius = 12
    }
    
    private func fillInfo(with furniture: Furniture) {
        imageView.loadImage(from: furniture.imageUrl.absoluteString)
        
        nameLabel.text = furniture.name
        descriptionLabel.text = furniture.description
    }
}
