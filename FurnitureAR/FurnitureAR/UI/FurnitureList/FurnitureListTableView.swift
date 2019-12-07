//
//  FurnitureListTableView.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 06.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

protocol FurnitureListTableViewDelegate: AnyObject {
    func furnitureListPulledRefresh(_ furnitureList: FurnitureListTableView)
    func furnitureList(_ furnitureList: FurnitureListTableView,
                       didSelectFurniture selectedFurniture: Furniture,
                       withImage furnitureImage: UIImage?)
}

final class FurnitureListTableView: UITableView {
    
    // MARK: Interface
    
    var furnitureListDelegate: FurnitureListTableViewDelegate?
    
    // MARK: - Properties
    
    private var furnitures = [Furniture]()
    
    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureTableView()
    }
    
    // MARK: - Configuring
    
    private func configureTableView() {
        dataSource = self
        delegate = self

        rowHeight = 300
        separatorStyle = .none
        
        configureRefreshControl()
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
    }
    
    @objc
    private func refreshPulled(_ sender: UIRefreshControl) {
        furnitureListDelegate?.furnitureListPulledRefresh(self)
    }
    
    // MARK: - Client methods
    
    func insertNewFurnitures(_ newFurnitures: [Furniture]) {
        refreshControl?.endRefreshing()
        
        let filteredNewFurnitures = newFurnitures.filter { !isFurnitureAlreadyExist($0) }
        addToFurnituresList(filteredNewFurnitures)
    }
    
    // MARK: - Inserting new items
    
    private func addToFurnituresList(_ newFurnitures: [Furniture]) {
        guard newFurnitures.hasElements else { return }
        guard let startInsertingIndex = furnitures.lastElementIndex else {
            return
        }

        furnitures.insert(contentsOf: newFurnitures, at: startInsertingIndex)

        let insertedFurnituresIndexPaths = newFurnitures.enumerated().map {
            return IndexPath(row: startInsertingIndex + $0.offset, section: .zero)
        }
        
        performBatchUpdates({
            self.insertRows(at: insertedFurnituresIndexPaths,
                            with: .right)
        }, completion: nil)
    }
    
    private func isFurnitureAlreadyExist(_ furnitureToFind: Furniture) -> Bool {
        return furnitures.contains { $0.id == furnitureToFind.id }
    }
}

// MARK: - Data source
extension FurnitureListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return furnitures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FurnitureTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = furnitures[indexPath.row]
        return cell
    }
}

// MARK: - Delegate
extension FurnitureListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as? FurnitureTableViewCell
        let selectedFurnitureImage = selectedCell?.furnitureImage
        
        furnitureListDelegate?.furnitureList(self, didSelectFurniture: furnitures[indexPath.row],
                                             withImage: selectedFurnitureImage)
    }
}
