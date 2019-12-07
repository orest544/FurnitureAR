//
//  FurnitureListViewController.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 06.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

final class FurnitureListViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var furnitureListTableView: FurnitureListTableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let furnitureService = FurnitureService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        furnitureListTableView.furnitureListDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchFurnitures()
    }
    
    // MARK: - Methods
    
    private func fetchFurnitures() {
        furnitureService.retrieveAll { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            switch result {
            case .success(let furnitures):
                DispatchQueue.main.async {
                    self?.furnitureListTableView.insertNewFurnitures(furnitures)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorMessage(error.message)
                }
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        let messageController = NativeAlertProvider.networkingProblems(message)
        present(messageController, animated: true)
    }
    
    private func openDetails(of furniture: Furniture, furnitureImage: UIImage?) {
        let furnitureDetailsViewController = UIStoryboard.Furniture.details
        furnitureDetailsViewController.selectedFurniture = furniture
        furnitureDetailsViewController.selectedFurnitureImage = furnitureImage
        
        navigationController?.pushViewController(furnitureDetailsViewController,
                                                 animated: true)
    }
}

// MARK: - FurnitureListTableViewDelegate
extension FurnitureListViewController: FurnitureListTableViewDelegate {
    func furnitureListPulledRefresh(_ furnitureList: FurnitureListTableView) {
        fetchFurnitures()
    }
    
    func furnitureList(_ furnitureList: FurnitureListTableView,
                       didSelectFurniture selectedFurniture: Furniture,
                       withImage furnitureImage: UIImage?) {
        openDetails(of: selectedFurniture, furnitureImage: furnitureImage)
    }
}
