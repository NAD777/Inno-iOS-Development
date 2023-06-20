//
//  ViewController.swift
//  PersonCard
//
//  Created by Антон Нехаев on 19.06.2023.
//

import UIKit

struct UserInfo {
    var title: String, description: String
}

class ViewController: UIViewController {
    var circle: UIView!
    var nameCircleLabel: UILabel!
    var nameTextField: UITextField!
    var nameButton: UIButton!
    var underScore: UIView!
    var personalInfoTable: UITableView!
    var userInfoRows: [UserInfo]! {
        didSet {
            personalInfoTable.reloadData()
        }
    }
    override func loadView() {
        super.loadView()
        print(#function, "Called when a view controller needs to load its view hierarchy. It is responsible for creating and initializing the view associated with the view controller.")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
        
        userInfoRows = [UserInfo(title: "University", description: "Here will be info about your university, you can put for example address of your university"),
                        UserInfo(title: "City", description: "Place for City")]
        print(#function, "Called after a view controller's view hierarchy has been loaded. It is invoked when the view controller has finished setting up its views and is about to be presented on the screen.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function, "Called just before a view controller's view is about to appear on the screen. It is invoked every time the view is about to become visible, whether it is being presented for the first time or being rediscovered after being hidden or covered by another view.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function, "Called after a view controller's view has appeared on the screen. It is invoked every time the view becomes visible to the user, whether it is being presented for the first time or being rediscovered after being hidden or covered by another view.")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circle.asCircle()
        print(#function, "Called after the view controller's view has finished laying out its subviews. It is invoked when the view's layout has been updated, which can occur due to various reasons such as orientation changes, size adjustments, or manual layout updates.")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function, "Called just before a view controller's view is about to disappear from the screen. It is invoked when the view is being removed from the screen, either because another view is being presented or because the view controller is being dismissed or popped from a navigation stack.")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function, "Called after a view controller's view has disappeared from the screen. It is invoked once the view is no longer visible to the user, either because it has been dismissed, popped from a navigation stack, or hidden by another view.")
    }
    
    func setUpUI() {
        view.backgroundColor = .white
        setUpCircle()
        setUpName()
        setUpNameInCircle()
        setUpUserInfo()
        
    }
    
    func setUpCircle() {
        circle = UIView()
        circle.backgroundColor = UIColor(red: 229 / 255,
                                         green: 229 / 255,
                                         blue: 234 / 255,
                                         alpha: 1)
        circle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circle)
        
        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            circle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            circle.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            circle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setUpNameInCircle() {
        nameCircleLabel = UILabel()
        nameCircleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        circle.addSubview(nameCircleLabel)
        
        NSLayoutConstraint.activate([
            nameCircleLabel.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            nameCircleLabel.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
        ])
        
        nameCircleLabel.textAlignment = .center
        nameCircleLabel.font = .init(name:"HelveticaNeue-Bold", size: 80.0)
        nameCircleLabel.textColor = .black
    }
    
    func setUpName() {
        nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
            
        ])
        nameTextField.textAlignment = .center
        
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Press to change name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        nameTextField.textColor = .black
        nameTextField.font = .init(name:"HelveticaNeue", size: 25.0)
        nameTextField.delegate = self
        
        
        underScore = UIView()
        underScore.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(underScore)
        NSLayoutConstraint.activate([
            underScore.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 4),
            underScore.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            underScore.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            underScore.heightAnchor.constraint(equalToConstant: 1)
        ])
        underScore.backgroundColor = .black
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
    
    func changeName(name: String) {
        let tokens = name.split(separator: " ")
        let firstLatters = tokens.reduce("") { x, y  in
            x + String(y.first!)
        }
        nameCircleLabel.text = firstLatters
        nameTextField.text = name
    }
    
    func setUpUserInfo() {
        
        personalInfoTable = PersonInfoTable()
        personalInfoTable.translatesAutoresizingMaskIntoConstraints = false
        personalInfoTable.rowHeight = UITableView.automaticDimension
        personalInfoTable.estimatedRowHeight = 100
        personalInfoTable.separatorColor = UIColor.clear
        personalInfoTable.isScrollEnabled = false
        personalInfoTable.delegate = self
        personalInfoTable.dataSource = self
        personalInfoTable.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
        
        view.addSubview(personalInfoTable)
        NSLayoutConstraint.activate([
            personalInfoTable.topAnchor.constraint(equalTo: underScore.bottomAnchor, constant: 20),
            personalInfoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            personalInfoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

class PersonInfoTable: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(.infinity, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField == nameTextField else {
            return false
        }
        oneLinePrompt(placeHolderText: "Name") { [weak self] text in
            self?.changeName(name: text)
        }
        return false
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
        
        cell.setInfo(info: userInfoRows[indexPath.row]) { [weak self, row = indexPath.row] in
            self?.oneLinePrompt(placeHolderText: self?.userInfoRows[row].title, submit: {
                [weak self, row = indexPath.row] text in
                    self?.userInfoRows[row].description = text
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userInfoRows.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

class InfoCell: UITableViewCell {
    var title: UILabel!
    var detailsLabel: UILabel!
    var editButton: UIButton!
    var editButtonPress: (() -> Void)?
    
    func setInfo(title: String, details: String, editButtonPress: (() -> Void)? = nil) {
        self.title.text = title
        self.detailsLabel.text = details
        self.editButtonPress = editButtonPress
    }
    
    func setInfo(info: UserInfo, editButtonPress: (() -> Void)? = nil) {
        self.title.text = info.title
        self.detailsLabel.text = info.description
        self.editButtonPress = editButtonPress
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        title = UILabel()
        detailsLabel = UILabel()
        editButton = UIButton()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(editButton)
        title.textColor = .gray
        detailsLabel.textColor = .black
        detailsLabel.numberOfLines = 0
        
        detailsLabel.font = .init(name:"HelveticaNeue", size: 18.0)
        
        editButton.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
        
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .large)
        editButton.setImage(UIImage(systemName: "pencil.tip.crop.circle.badge.plus", withConfiguration: largeConfig), for: .normal)
        editButton.tintColor = .gray
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: 5.0),
            title.heightAnchor.constraint(equalToConstant: 18.0),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: 5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: title.bottomAnchor,
                                              constant:4.0),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -12.0),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: 5),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -45)
        ])
        
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: detailsLabel.centerYAnchor),
            editButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -4.0),
            editButton.leadingAnchor.constraint(equalTo: detailsLabel.trailingAnchor,
                                                constant: 5),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        self.backgroundColor = .white
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

extension UIView {
    func asCircle() {
        self.layer.cornerRadius = self.frame.width / 2
    }
}
