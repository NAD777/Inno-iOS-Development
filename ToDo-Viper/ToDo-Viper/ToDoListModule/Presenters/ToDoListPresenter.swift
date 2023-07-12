//
//  ToDoListPresenter.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation


protocol ToDoListPresenterProtocol: AnyObject {
    var view: ToDoListView? { get set }
    
    func viewDidLoad()
    
    func addToDo(_ toDo: ToDoItem)
    
    func deleteToDo(_ toDo: ToDoItem)
    
    func showToDoDetails(_ toDo: ToDoItem)
    
    func addButtonTapped()
}

class ToDoListPresenter: ToDoListPresenterProtocol {
    weak var view: ToDoListView?
    var iteractor: ToDoListIteracorInputProtocol?
    weak var output: ToDoListModuleOutput?
    
    init(iteractor: ToDoListIteracorInputProtocol?, output: ToDoListModuleOutput?) {
        self.iteractor = iteractor
        self.output = output
    }
    
    
    func viewDidLoad() {
        iteractor?.getToDos()
    }
    
    func addToDo(_ toDo: ToDoItem) {
        iteractor?.saveToDo(toDo)
    }
    
    func deleteToDo(_ toDo: ToDoItem) {
        iteractor?.deleteToDo(toDo)
    }
    
    func showToDoDetails(_ toDo: ToDoItem) {
        guard let view else { return }
        output?.modulePresentDetails(from: view, for: toDo)
    }
    
    func addButtonTapped() {
        guard let view else { return } 
        output?.modulePresentDetails(from: view, for: nil)
    }
}

extension ToDoListPresenter: ToDoListIteracorOutputProtocol {
    func didSaveToDo() {
        iteractor?.getToDos()
    }
    
    func didGetToDos(_ toDos: [ToDoItem]) {
        view?.showToDos(toDos)
    }
    
    func didRemoveToDo() {
        iteractor?.getToDos()
    }
}
