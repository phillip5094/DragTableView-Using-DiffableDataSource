//
//  Person.swift
//  DragTableView-Using-DiffableDataSource
//
//  Created by NHN on 2022/02/19.
//

import Foundation

struct Person: Hashable {
    let name: String
    let id = UUID()
}

extension Person {
    static var data = [
        Person(name: "Philip"),
        Person(name: "Emma"),
        Person(name: "John"),
        Person(name: "Micle"),
        Person(name: "David"),
        Person(name: "Tom"),
    ]
}
