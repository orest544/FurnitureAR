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

        rowHeight = 300
        separatorStyle = .none
    }
    
    func insertNewFurnitures(_ newFurnitures: [Furniture]) {        
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
                            with: .right)
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
        let cell: FurnitureTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = furnitures[indexPath.row]
        return cell
    }
}

extension FurnitureListTableView: UITableViewDelegate {
    
}
