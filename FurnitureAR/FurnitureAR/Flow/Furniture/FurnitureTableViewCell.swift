//
//  FurnitureTableViewCell.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 06.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

final class FurnitureTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet private weak var backShadowView: UIView!
    @IBOutlet private weak var backgroundImageView: LoadingImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private let cornerRadius = CGFloat(12)
    
    var viewModel: Furniture? {
        didSet {
            guard let model = viewModel else {
                 return
            }
            configureCell(with: model)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearence()
    }
    
    private func configureAppearence() {
        backShadowView.layer.cornerRadius = cornerRadius
        backgroundImageView.layer.cornerRadius = cornerRadius
        applyShadow()
    }
    
    private func applyShadow() {
        backShadowView.layer.shadowColor = UIColor.black.cgColor
        backShadowView.layer.shadowOpacity = 0.13
        backShadowView.layer.shadowOffset = .zero
        backShadowView.layer.shadowRadius = 6
    }
    
    private func configureCell(with furniture: Furniture) {
        backgroundImageView.loadImage(from: furniture.imageUrl.absoluteString)
        
        nameLabel.text = furniture.name
        descriptionLabel.text = furniture.description
    }
}