//
//  ToDoDetailPresenter.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation


protocol ToDoDetailPresenterProtocol: AnyObject {
    var view: ToDoDetailView? { get set }
    
    func viewDidLoad()
    
    func editOrAddToDo(title: String, content: String)
    
    func deleteToDo()
}

final class ToDoDetailPresenter: ToDoDetailPresenterProtocol {
    weak var view: ToDoDetailView?
    var iteractor: ToDoDetailIteractorInputProtocol?
    weak var output: ToDoDetailModuleOutput?
    
    init(iteractor: ToDoDetailIteractorInputProtocol?, output: ToDoDetailModuleOutput?) {
        self.iteractor = iteractor
        self.output = output
    }
    
    func viewDidLoad() {
        if let item = iteractor?.toDoItem {
            view?.showToDo(item)
        }
    }
    
    func editOrAddToDo(title: String, content: String) {
        iteractor?.editOrAddToDo(title: title, content: content)
    }
    
    func deleteToDo() {
        iteractor?.deleteToDo()
    }
}


extension ToDoDetailPresenter: ToDoDetailIteractorOutputProtocol {
    func didEditOrAdd() {
        guard let view else { return }
        output?.backToToDoList(from: view)
    }
    
    func didDelete() {
        guard let view else { return }
        output?.backToToDoList(from: view)
    }
}
