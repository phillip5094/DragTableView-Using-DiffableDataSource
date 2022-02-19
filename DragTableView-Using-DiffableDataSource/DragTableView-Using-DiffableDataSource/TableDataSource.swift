//
//  TableDataSource.swift
//  DragTableView-Using-DiffableDataSource
//
//  Created by NHN on 2022/02/19.
//

import Foundation
import UIKit

class TableDataSource: UITableViewDiffableDataSource<Section, Person> {
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let fromItem = itemIdentifier(for: sourceIndexPath),
              let toItem = itemIdentifier(for: destinationIndexPath),
              sourceIndexPath != destinationIndexPath else { return }
        
        var snap = snapshot()
        snap.deleteItems([fromItem])
        
        if destinationIndexPath.row > sourceIndexPath.row {
            snap.insertItems([fromItem], afterItem: toItem)
        } else {
            snap.insertItems([fromItem], beforeItem: toItem)
        }
            
        apply(snap, animatingDifferences: false)
    }
}
