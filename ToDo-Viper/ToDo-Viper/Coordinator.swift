//
//  Coordinator.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import Foundation

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    
    func start()
}
