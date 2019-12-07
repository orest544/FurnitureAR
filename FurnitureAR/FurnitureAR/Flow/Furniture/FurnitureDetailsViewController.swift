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
    @IBOutlet private weak var tryWithARButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var selectedFurniture: Furniture?
    var selectedFurnitureImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    private func configureSubviews() {
        if let furniture = selectedFurniture {
            fillInfo(with: furniture)
        }
        tryWithARButton.layer.cornerRadius = 12
    }
    
    private func fillInfo(with furniture: Furniture) {
        if let furnitureImage = selectedFurnitureImage {
            imageView.image = furnitureImage
        } else {
            imageView.loadImage(from: furniture.imageUrl.absoluteString)
        }
        
        nameLabel.text = furniture.name
        descriptionLabel.text = furniture.description
    }
    
    @IBAction private func tryWithAR(_ sender: UIButton) {
        guard let furniture = selectedFurniture else {
            return
        }
        let ARViewController = UIStoryboard.AR.initial
        ARViewController.virtualObjectId = furniture.id
        
        present(ARViewController, animated: true)
    }
}
