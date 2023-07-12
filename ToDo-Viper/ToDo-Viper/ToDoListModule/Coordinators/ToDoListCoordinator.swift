//
//  ToDoListCoordinator.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation
import UIKit


protocol ToDoListModuleOutput: AnyObject {
    func modulePresentDetails(from view: ToDoListView, for toDo: ToDoItem?)
}

final class ToDoListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let factory = ToDoListFactory(output: self)
        let viewController = factory.produce()
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension ToDoListCoordinator: ToDoListModuleOutput {
    func modulePresentDetails(from view: ToDoListView, for toDo: ToDoItem? = nil) {
        let factory = ToDoDeltailFactory(output: self, toDoItem: toDo)
        let viewController =  factory.produce()
        
        guard let view = view as? UIViewController else { return }
        
        view.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ToDoListCoordinator: ToDoDetailModuleOutput {
    func backToToDoList(from view: ToDoDetailView) {
        guard let toDoDeltailViewController = view as? ToDoDetailViewController else { return }
        toDoDeltailViewController.navigationController?.popViewController(animated: true)
    }
}
