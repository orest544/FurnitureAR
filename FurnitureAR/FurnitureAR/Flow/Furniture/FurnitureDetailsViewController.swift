//
//  FurnitureDetailsViewController.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 07.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

final class FurnitureDetailsViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: LoadingImageView!
    @IBOutlet private weak var tryWithARButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Interface
    
    var selectedFurnitureDetails: FurnitureDetails?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    // MARK: - Methods
    
    private func configureSubviews() {
        if let furniture = selectedFurnitureDetails?.furniture {
            fillInfo(with: furniture)
        }
        tryWithARButton.layer.cornerRadius = 12
    }
    
    private func fillInfo(with furniture: Furniture) {
        if let furnitureImage = selectedFurnitureDetails?.image {
            imageView.image = furnitureImage
        } else {
            imageView.loadImage(from: furniture.imageUrl.absoluteString)
        }
        
        nameLabel.text = furniture.name
        descriptionLabel.text = furniture.description
    }
    
    // MARK: - IBActions
    
    @IBAction private func tryWithAR(_ sender: UIButton) {
        guard let furniture = selectedFurnitureDetails?.furniture else {
            return
        }
        
        let arViewController = UIStoryboard.AR.initial
        arViewController.virtualObjectId = furniture.id
        
        present(arViewController, animated: true)
    }
}

// MARK: - Types
extension FurnitureDetailsViewController {
    typealias FurnitureDetails = (furniture: Furniture?, image: UIImage?)
}
