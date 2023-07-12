//
//  ToDoListViewController.swift
//  ToDo-Viper
//
//  Created by Антон Нехаев on 11.07.2023.
//

import UIKit


protocol ToDoListView: AnyObject {
    var presenter: ToDoListPresenterProtocol? { get set }
    
    func showToDos(_ toDos: [ToDoItem])
}

final class ToDoListViewController: UIViewController, ToDoListView {
    // MARK: - View protocol implementations
    var presenter: ToDoListPresenterProtocol?
    
    func showToDos(_ toDos: [ToDoItem]) {
        self.toDos = toDos
    }
    
    // MARK: - Private properties
    private var toDos = [ToDoItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewDidLoad()
    }
    
    // MARK: - Layout setup
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addSubviews()
        convigureNavigationBar()
        NSLayoutConstraint.activate(staticConstrains())
        presenter?.viewDidLoad()
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func convigureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        presenter?.addButtonTapped()
    }
    
    func staticConstrains() -> [NSLayoutConstraint] {
        var constaints = [NSLayoutConstraint]()
        
        constaints.append(contentsOf: [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return constaints
    }
}


// MARK: - Table view
extension ToDoListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle != .delete {
            return
        }
        presenter?.deleteToDo(toDos[indexPath.row])
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = toDos[indexPath.row]
        presenter?.showToDoDetails(item)
    }
}

extension ToDoListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Cell.reuseIdentifier,
            for: indexPath) as? Cell
        else { return UITableViewCell() }
        
        cell.configure(with: toDos[indexPath.row])
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if toDos.isEmpty {
            tableView.setEmptyDataView(
                image: UIImage(named: "NoResultsImage") ?? UIImage(systemName: "book")!,
                title: "No ToDos so far"
            )
        } else {
            tableView.removeEmptyDataView()
        }
        
        return toDos.count
    }
    
}


class Cell: UITableViewCell {
    private let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .gray
        
        return title
    }()
    
    
    var detailsLabel: UILabel = {
        let detailsLabel = UILabel()
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.textColor = .black
        detailsLabel.numberOfLines = 0
        detailsLabel.font = .init(name:"HelveticaNeue", size: 18.0)
        
        return detailsLabel
    }()
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    func setInfo(title: String, details: String) {
        self.title.text = title
        self.detailsLabel.text = details
    }
    
    
    func configure(with data: ToDoItem) {
        title.text = data.title
        detailsLabel.text = data.content
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(detailsLabel)
        
        self.backgroundColor = .white
        NSLayoutConstraint.activate(staticConstraints())
    }
    
    func staticConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            title.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: 5.0),
            title.heightAnchor.constraint(lessThanOrEqualToConstant: 18),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: 5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        constraints.append(contentsOf: [
            detailsLabel.topAnchor.constraint(equalTo: title.bottomAnchor,
                                              constant: 8.0),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -12.0),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 5),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -45)
        ])
        
        return constraints
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
