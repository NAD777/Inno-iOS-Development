//
//  DetailsViewController.swift
//  Ricked
//
//  Created by Антон Нехаев on 27.06.2023.
//

import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func detailsViewController(
        _ detailsViewController: DetailsViewController,
        didFinishEditing item: Character?
    )
}

class DetailsViewController: UIViewController {
    weak var delegate: DetailsViewControllerDelegate?
    var data: Character?
    
    private let imageView = UIImageView()
    
    private let stateCircle = UIView()
    
    private let stateLabel: UILabel = {
        let stateLabel = UILabel()
        stateLabel.textColor = .white
        stateLabel.textAlignment = .center
        return stateLabel
    }()
    
    private let infoTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .background
        table.isScrollEnabled = false
        table.register(InfoCell.self,
                       forCellReuseIdentifier: InfoCell.reuseIdentifier)
        table.layer.cornerRadius = 8
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        view.addSubview(stateCircle)
        view.addSubview(imageView)
        view.addSubview(stateLabel)
        view.addSubview(infoTable)
        infoTable.dataSource = self
        infoTable.delegate = self
        
        setUpUI()
        setUpData(data)
    }
    
    private func setUpData(_ data: Character?) {
        guard let data else { return }
//        imageView.image = UIImage(named: data.image)
        imageView.download(from: data.image)
        
        switch data.status {
        case .alive:
            stateCircle.backgroundColor = .systemGreen
            stateLabel.backgroundColor = .systemGreen
        case .dead:
            stateCircle.backgroundColor = .systemRed
            stateLabel.backgroundColor = .systemRed
        case .unknown:
            stateCircle.backgroundColor = .systemGray
            stateLabel.backgroundColor = .systemGray
        }
        stateLabel.text = data.getStatusString()
    }
    
    func setUpUI() {
        setUpState()
        setUpImage()
        setUpTable()
    }
    
    func setUpImage() {
        imageView.frame = CGRect(x: view.frame.midX - 100, y: 30, width: 200, height: 200)
        imageView.roundCorners()
        imageView.clipsToBounds = true
    }
    
    func setUpState() {
        stateCircle.frame = CGRect(x: view.frame.midX - 104, y: 26, width: 208, height: 208)
        stateCircle.roundCorners()
        stateCircle.backgroundColor = .systemGreen
        stateCircle.clipsToBounds = true
        
        let stateLabelWidth = 75
        let placeHolder = UIView(frame: .init(x: Int(view.frame.midX) - stateLabelWidth / 2, y: 220,
                                              width: stateLabelWidth, height: 30))
        view.addSubview(placeHolder)
        stateLabel.frame = CGRect(x: Int(view.frame.midX) - stateLabelWidth / 2, y: 220, width: stateLabelWidth, height: 30)
    }
    
    func setUpTable() {
        
        NSLayoutConstraint.activate([
            infoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoTable.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 10),
            infoTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
        
    }
}

extension DetailsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        false
    }
    
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "InfoCell", for: indexPath) as? InfoCell else { return UITableViewCell() }
        guard let data else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.setInfo(title: "Name", details: data.name, editable: true) { [weak self] in
                self?.oneLinePrompt(submit: {
                    [weak self] text in
                    guard let selfClass = self else { return }
                    self?.data?.name = text
                    self?.infoTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    self?.delegate?.detailsViewController(selfClass,
                                                          didFinishEditing: self?.data)
                })
            }
        case 1:
            cell.setInfo(title: "Gender", details: data.getGenderString())
        case 2:
            cell.setInfo(title: "Species", details: data.species, editable: true) { [weak self] in
                self?.oneLinePrompt(submit: {
                    [weak self] text in
                    guard let selfClass = self else { return }
                    self?.data?.species = text
                    self?.infoTable.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                    self?.delegate?.detailsViewController(selfClass,
                                                          didFinishEditing: self?.data)
                })
            }
        case 3:
            cell.setInfo(title: "Status", details: data.getStatusString())
        case 4:
            cell.setInfo(title: "Location", details: data.location)
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func oneLinePrompt(placeHolderText: String? = nil, submit: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Enter new value",
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addTextField()
        if let placeHolderText = placeHolderText {
            alert.textFields?.first?.placeholder = placeHolderText
        }
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default) {
            [weak alert] action in
            guard let answer = alert?.textFields?[0].text else { return }
            submit(answer)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

class InfoCell: UITableViewCell {
    var title: UILabel = {
        var title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .gray
        return title
    }()
    var detailsLabel: UILabel = {
        var detailsLabel = UILabel()
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.textColor = .black
        detailsLabel.numberOfLines = 0
        detailsLabel.font = .init(name:"HelveticaNeue", size: 18.0)
        
        return detailsLabel
    }()
    var editButton: UIButton!
    var editButtonPress: (() -> Void)?
    var editable: Bool = false
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    func setInfo(title: String, details: String, editable: Bool = false, editButtonPress: (() -> Void)? = nil) {
        self.title.text = title
        self.detailsLabel.text = details
        self.editButtonPress = editButtonPress
        self.editable = editable
        
        if self.editable {
            editButton = UIButton()
            editButton.translatesAutoresizingMaskIntoConstraints = false
            editButton.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
            contentView.addSubview(editButton)
            editButton.tintColor = .gray
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .large)
            editButton.setImage(UIImage(systemName: "pencil.tip.crop.circle.badge.plus", withConfiguration: largeConfig), for: .normal)
            NSLayoutConstraint.activate([
                editButton.centerYAnchor.constraint(equalTo: detailsLabel.centerYAnchor),
                editButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -4.0),
                editButton.leadingAnchor.constraint(equalTo: detailsLabel.trailingAnchor,
                                                    constant: 5),
                editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
    }
    
    private func staticConstraints() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(contentsOf: [
            title.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: 5.0),
            title.heightAnchor.constraint(equalToConstant: 18.0),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: 10),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        
        constraints.append(contentsOf: [
            detailsLabel.topAnchor.constraint(equalTo: title.bottomAnchor,
                                              constant:4.0),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -12.0),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 10),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -45)
        ])
        return constraints
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        contentView.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate(staticConstraints())
        
        self.backgroundColor = .cellBackground
    }
    
    @objc func pressButton() {
        if let callback = editButtonPress {
            callback()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
