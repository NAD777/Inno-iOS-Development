//
//  ViewController.swift
//  Ricked
//
//  Created by Антон Нехаев on 27.06.2023.
//

import UIKit

class ViewController: UIViewController {
    private let manager: NetworkManagerProtocol = NetworkManger()
    
    private var data: [Character] = []
    
    private let tableOfContent: UITableView = {
        let tableOfContent = UITableView()
        tableOfContent.translatesAutoresizingMaskIntoConstraints = false
        tableOfContent.backgroundColor = .background
        tableOfContent.register(ContentCell.self,
                                forCellReuseIdentifier: ContentCell.reuseIdentifier)
        tableOfContent.register(EmptyCell.self,
                                forCellReuseIdentifier: EmptyCell.reuseIdentifier)
        tableOfContent.separatorColor = .clear
        tableOfContent.showsVerticalScrollIndicator = false
        tableOfContent.showsHorizontalScrollIndicator = false
        return tableOfContent
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableOfContent.delegate = self
        tableOfContent.dataSource = self
        view.backgroundColor = .background
        
        view.addSubview(tableOfContent)
        
        NSLayoutConstraint.activate(staticConstraints())
        loadCharacters()
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            tableOfContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableOfContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableOfContent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableOfContent.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return constraints
    }
    
    func reloadData() {
        tableOfContent.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row / 2
        let detailsViewController = DetailsViewController()
        detailsViewController.delegate = self
        detailsViewController.data = data[index]
        present(detailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row % 2 == 1 ? 15: 115
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        data.count * 2 - 1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if indexPath.row % 2 == 1 {
            let emptyCell = EmptyCell()
            return emptyCell
        }
        guard let cell = tableOfContent.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as? ContentCell  else { return UITableViewCell() }
        let index = indexPath.row / 2
        
        cell.setUpCell(data: data[index])
        return cell
    }
}

extension ViewController: DetailsViewControllerDelegate {
    func detailsViewController(
        _ detailsViewController: DetailsViewController,
        didFinishEditing item: Character?
    ) {
        guard let item else { return }
        for i in 0..<data.count {
            if data[i].id == item.id {
                data[i] = item
                tableOfContent.reloadRows(at: [IndexPath(row: 2 * i, section: 0)],
                                          with: .automatic)
                return
            }
        }
    }
}

// MARK: - networking
extension ViewController {
    func convertToUIModels(_ welcome: CharacterResponseWelcome ) -> [Character] {
        var results: [Character] = .init()
        
        for result in welcome.results {
            var status: Character.Status = .unknown
            switch result.status {
            case .alive:
                status = .alive
            case .dead:
                status = .dead
            case .unknown:
                status = .unknown
            }

            var gender: Character.Gender = .unknown
            switch result.gender {
            case .female:
                gender = .female
            case .genderless:
                gender = .genderless
            case .male:
                gender = .male
            case .unknown:
                gender = .unknown
            }
            let character = Character(id: result.id, name: result.name, status: status,
                                      species: result.species, gender: gender, location: result.location.name, image: result.image)
            
            results.append(character)
        }
        return results
    }
    
    func loadCharacters() {
        manager.fetchCharacters { result in
            switch result {
            case let .success(responce):
                self.data = self.convertToUIModels(responce)
                self.reloadData()
            case .failure:
                print(1)
                return
            }
        }
    }
}

final class ContentCell: UITableViewCell {
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderWidth = 1
    }
    
    
    private let imageUI: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .init(name:"HelveticaNeue-Bold", size: 20.0)
        label.textColor = .black
        
        label.underline()
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let bottomLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let bottomRightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let vStack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let hStackBottom: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    public let liveIndicator: UIView = {
        var circle = UIView()
        circle.backgroundColor = .red
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()

    func setUpCell(data: Character) {
        title.text = data.name
        subTitle.text = data.species
        imageUI.download(from: data.image)
        switch data.status {
        case .alive:
            liveIndicator.backgroundColor = .systemGreen
        case .dead:
            liveIndicator.backgroundColor = .systemRed
        case .unknown:
            liveIndicator.backgroundColor = .systemGray
        }
        bottomLeftLabel.text = data.getStatusString()
        bottomRightLabel.text = data.getGenderString()
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        liveIndicator.roundCorners()
    }

    private func commonInit() {
        contentView.backgroundColor = .cellBackground
        contentView.addSubview(containerView)
        containerView.addSubview(imageUI)
        containerView.addSubview(vStack)
        vStack.addArrangedSubview(title)
        containerView.addSubview(liveIndicator)
        
        
        vStack.addArrangedSubview(subTitle)
        vStack.addArrangedSubview(hStackBottom)
        hStackBottom.addArrangedSubview(bottomLeftLabel)
        hStackBottom.addArrangedSubview(bottomRightLabel)
        
        NSLayoutConstraint.activate(staticConstraints())
        liveIndicator.roundCorners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func staticConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        
        constraints.append(contentsOf: [
            imageUI.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2),
            imageUI.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2),
            imageUI.widthAnchor.constraint(equalToConstant: 100),
            imageUI.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        constraints.append(contentsOf: [
            vStack.leadingAnchor.constraint(equalTo: imageUI.trailingAnchor, constant: 15),
            vStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            vStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            vStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
        ])
        
        constraints.append(contentsOf: [
            liveIndicator.widthAnchor.constraint(equalToConstant: 10),
            liveIndicator.heightAnchor.constraint(equalToConstant: 10),
            liveIndicator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3),
            liveIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 3),
        ])
        
        return constraints
    }
}


final class EmptyCell: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    private func commonInit() {
        contentView.backgroundColor = .background
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
