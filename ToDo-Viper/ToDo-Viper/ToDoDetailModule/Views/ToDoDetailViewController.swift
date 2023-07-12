//
//  ToDoDetailViewController.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import UIKit

protocol ToDoDetailView: AnyObject {
    var presenter: ToDoDetailPresenterProtocol? { get set }
    
    func showToDo(_ todo: ToDoItem)
}

class ToDoDetailViewController: UIViewController, ToDoDetailView {
    
    // MARK: - Protocol implementation
    var presenter: ToDoDetailPresenterProtocol?
    
    func showToDo(_ toDo: ToDoItem) {
        titleTextField.text = toDo.title
        contentTextView.text = toDo.content
    }
    
    // MARK: - private properties
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false

        titleTextField.textAlignment = .center
        titleTextField.textColor = .systemGray
        titleTextField.placeholder = "Title"
        
        return titleTextField
    }()
    
    private let contentTextView: UITextView = {
        let contentTextView = UITextView()
        
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.textColor = .systemBlue
        contentTextView.text = "Your content"
        
        return contentTextView
    }()
    
    // MARK: - Layout setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        
        NSLayoutConstraint.activate(staticConstrains())
        
        setUpNavigationBar()
        presenter?.viewDidLoad()
    }
    
    private func setUpNavigationBar() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
        navigationItem.rightBarButtonItems = [done, delete]
    }
    
    @objc private func doneButtonTapped() {
        presenter?.editOrAddToDo(title: titleTextField.text ?? "", content: contentTextView.text ?? "")
    }
    
    @objc private func deleteButtonTapped() {
        presenter?.deleteToDo()
    }
    
    func staticConstrains() -> [NSLayoutConstraint] {
        var constrains = [NSLayoutConstraint]()
        
        constrains.append(contentsOf: [
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        constrains.append(contentsOf: [
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            contentTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            contentTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        return constrains
    }
}

