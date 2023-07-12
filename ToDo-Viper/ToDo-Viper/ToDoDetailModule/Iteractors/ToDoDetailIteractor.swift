//
//  ToDoDetailIteractor.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation


protocol ToDoDetailIteractorInputProtocol: AnyObject {
    var presenter: ToDoDetailIteractorOutputProtocol? { get set }
    var toDoItem: ToDoItem? { get set }
    
    func deleteToDo()
    func editOrAddToDo(title: String, content: String)
}

protocol ToDoDetailIteractorOutputProtocol: AnyObject {
    func didEditOrAdd()
    func didDelete()
}

final class ToDoDetailIteractor: ToDoDetailIteractorInputProtocol {
    weak var presenter: ToDoDetailIteractorOutputProtocol?
    var toDoItem: ToDoItem?
    
    func deleteToDo() {
        guard let toDoItem else { return }
        ToDoStore.shared.removeToDo(toDoItem)
        presenter?.didDelete()
    }
    
    func editOrAddToDo(title: String, content: String) {
        if let toDoItem {
            toDoItem.title = title
            toDoItem.content = content
        } else {
            ToDoStore.shared.addToDo(ToDoItem(title: title, content: content))
        }
        presenter?.didEditOrAdd()
    }
}
