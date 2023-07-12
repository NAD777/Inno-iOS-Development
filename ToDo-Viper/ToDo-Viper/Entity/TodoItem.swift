//
//  ToDoItem.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation

class ToDoItem {
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}


extension ToDoItem: Equatable {
    static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        lhs.content == rhs.content && lhs.content == rhs.content
    }
}
