//
//  ViewController.swift
//  DragTableView-Using-DiffableDataSource
//
//  Created by NHN on 2022/02/19.
//

import UIKit

enum Section: CaseIterable {
    case main
}

class ViewController: UIViewController {
    var people: [Person] = Person.data
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: TableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        // dataSource와 tableView 연결
        dataSource = TableDataSource(tableView: tableView) { (tableView, indexPath, person) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = person.name
            return cell
        }
        
        // apply를 사용해서 UI 업데이트
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(people, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


extension ViewController: UITableViewDragDelegate {
    // step 1
func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    guard let item = dataSource.itemIdentifier(for: indexPath) else { return [] }
    let itemProvider = NSItemProvider(object: item.id.uuidString as NSString)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    dragItem.localObject = item
    
    // step 2
    guard let cell = tableView.cellForRow(at: indexPath) else { return [dragItem] }
    let cellInsetContents = cell.contentView.bounds.insetBy(dx: 2.0 , dy: 2.0)
    
    // step 3
    dragItem.previewProvider = {
        // step 4
        let dragPreviewParams = UIDragPreviewParameters()
        dragPreviewParams.visiblePath = UIBezierPath(roundedRect:cellInsetContents, cornerRadius: 8.0)
        return UIDragPreview(view: cell.contentView, parameters: dragPreviewParams)
    }

    return [dragItem]
}
}

extension ViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
}
