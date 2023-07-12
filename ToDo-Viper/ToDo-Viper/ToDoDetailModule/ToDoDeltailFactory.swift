//
//  ToDoDeltailFactory.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation
import UIKit

class ToDoDeltailFactory {
    weak var output: ToDoDetailModuleOutput?
    var toDoItem: ToDoItem?

    init(output: ToDoDetailModuleOutput? = nil, toDoItem: ToDoItem?) {
        self.output = output
        self.toDoItem = toDoItem
    }
    
    func produce() -> UIViewController {
        let iteractor = ToDoDetailIteractor()
        let presenter = ToDoDetailPresenter(iteractor: iteractor, output: output)
        let view = ToDoDetailViewController()
        
        iteractor.presenter = presenter
        iteractor.toDoItem = toDoItem
        
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
