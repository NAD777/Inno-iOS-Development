//
//  ToDoStore.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation

class ToDoStore {
    private init() {}
    
    public static let shared = ToDoStore()
    
    public private(set) var toDos: [ToDoItem] = []
    
    func addToDo(_ toDo: ToDoItem) {
        toDos.append(toDo)
    }
    
    func removeToDo(_ toDo: ToDoItem) {
        guard let index = toDos.firstIndex(where: { item in
            item == toDo
        }) else { return }
        toDos.remove(at: index)
    }
}
