//
//  ToDoListFactory.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation
import UIKit

class ToDoListFactory {
    weak var output: ToDoListModuleOutput?
    
    init(output: ToDoListModuleOutput? = nil) {
        self.output = output
    }
    
    func produce() -> UIViewController {
        let iteractor = ToDoListIteractor()
        let presenter = ToDoListPresenter(iteractor: iteractor, output: output)
        let view = ToDoListViewController()
        
        iteractor.output = presenter
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}
