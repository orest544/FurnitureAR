//
//  FurnitureListTableView.swift
//  FurnitureAR
//
//  Created by Orest Patlyka on 06.12.2019.
//  Copyright © 2019 Orest Patlyka. All rights reserved.
//

import UIKit

class FurnitureListTableView: UITableView {
    
    private var furnitures = [Furniture]()
    
    override init(frame: CGRect, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        configureTableView()
    }
    
    private func configureTableView() {
        dataSource = self
        delegate = self
        
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 100
        
        separatorStyle = .none
    }
    
    func insertNewFurnitures(_ newFurnitures: [Furniture]) {
        if furnitures.isEmpty {
            furnitures = newFurnitures
            reloadData()
            return
        }
        
        let filteredNewFurnitures = newFurnitures.filter { !isFurnitureAlreadyExist($0) }
        addToFurnituresList(filteredNewFurnitures)
    }
    
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
                            with: .fade)
        }, completion: nil)
    }
    
    private func isFurnitureAlreadyExist(_ furnitureToFind: Furniture) -> Bool {
        return furnitures.contains { $0.id == furnitureToFind.id }
    }
}

extension FurnitureListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return furnitures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Template
        return UITableViewCell()
    }
}

extension FurnitureListTableView: UITableViewDelegate {
    
}
