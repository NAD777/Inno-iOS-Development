//
//  ToDoListIteractor.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation

protocol ToDoListIteracorInputProtocol: AnyObject {
    var output: ToDoListIteracorOutputProtocol? { get set }
    
    func getToDos()
    
    func saveToDo(_ toDo: ToDoItem)
    
    func deleteToDo(_ toDo: ToDoItem)
    
}

protocol ToDoListIteracorOutputProtocol: AnyObject {
    func didRemoveToDo()
    
    func didGetToDos(_ toDos: [ToDoItem])
    
    func didSaveToDo()
}


class ToDoListIteractor: ToDoListIteracorInputProtocol {
    // MARK: - Input protocol implementation
    
    var output: ToDoListIteracorOutputProtocol?
    
    func getToDos() {
        output?.didGetToDos(ToDoStore.shared.toDos)
    }
    
    func saveToDo(_ toDo: ToDoItem) {
        ToDoStore.shared.addToDo(toDo)
        output?.didSaveToDo()
    }
    
    func deleteToDo(_ toDo: ToDoItem) {
        ToDoStore.shared.removeToDo(toDo)
        output?.didRemoveToDo()
    }
}
