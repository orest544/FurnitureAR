//
//  FurnitureListViewController.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 06.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

class FurnitureListViewController: UIViewController {
    
    @IBOutlet weak var furnitureListTableView: FurnitureListTableView!
    
    private let furnitureService = FurnitureService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        furnitureListTableView.furnitureListDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchFurnitures()
    }
    
    private func fetchFurnitures() {
        furnitureService.retrieveAll { [weak self] result in
            switch result {
            case .success(let furnitures):
                print("Success!\n", furnitures)
                DispatchQueue.main.async {
                    self?.furnitureListTableView.insertNewFurnitures(furnitures)
                }
            case .failure(let error):
                let errorWithInfo = error as NSError
                let messages = [
                    errorWithInfo.localizedDescription,
                    errorWithInfo.localizedFailureReason,
                    errorWithInfo.localizedRecoverySuggestion
                ]
                
                let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
                print(errorMessage)
            }
        }
    }
    
    private func openDetails(of furniture: Furniture) {
        let furnitureDetailsViewController = UIStoryboard.Furniture.details
        furnitureDetailsViewController.selectedFurniture = furniture

        navigationController?.pushViewController(furnitureDetailsViewController,
                                                 animated: true)
    }
}

extension FurnitureListViewController: FurnitureListTableViewDelegate {
    func furnitureListPulledRefresh(_ furnitureList: FurnitureListTableView) {
        fetchFurnitures()
    }
    
    func furnitureList(_ furnitureList: FurnitureListTableView,
                       didSelectFurniture selectedFurniture: Furniture) {
        openDetails(of: selectedFurniture)
    }
}
