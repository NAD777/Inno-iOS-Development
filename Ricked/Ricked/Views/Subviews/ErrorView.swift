//
//  ErrorView.swift
//  NetworkingExample
//
//  Created by r.latypov on 27.06.2023.
//

import UIKit

protocol RefreshDelegate: AnyObject {
    func refreshPage()
}

class ErrorView: UIView {

    // MARK: Private Constants

    private struct Constants {
        static let leading: CGFloat = 20
        static let trailing: CGFloat = 20

        static let stackViewTop: CGFloat = 209

        static let refreshPageButtonTop: CGFloat = 209
        static let refreshPageButtonHeight: CGFloat = 50
    }

    weak var delegate: RefreshDelegate?

    // MARK: - Private properties

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()

    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "errorImage")
        imageView.tintColor = UIColor(named: "mainTextFontColor")
        return imageView
    }()

    private let errorTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Something went wrong..."
        label.font = UIFont(name: Fonts.ubuntuRegular, size: 32)
        label.textColor = UIColor(named: "mainTextFontColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Try to reload the page or re-enter the application."
        label.font = UIFont(name: Fonts.ubuntuRegular, size: 14)
        label.textColor = UIColor(named: "secondaryTextFontColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let refreshPageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.blueButton
        button.setTitle("Refresh", for: .normal)
        button.addTarget(self, action: #selector(refreshPageButtonAction), for: .touchUpInside)
        return button
    }()

    @objc func refreshPageButtonAction() {
        delegate?.refreshPage()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Private metohds
    private func setup() {
        stackView.addArrangedSubview(errorImageView)
        stackView.addArrangedSubview(errorTextLabel)
        stackView.addArrangedSubview(secondaryTextLabel)

        addSubview(stackView)
        addSubview(refreshPageButton)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.stackViewTop)
            make.leading.equalToSuperview().inset(Constants.leading)
            make.trailing.equalToSuperview().inset(Constants.trailing)
        }

        refreshPageButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(Constants.refreshPageButtonTop)
            make.leading.equalToSuperview().inset(Constants.leading)
            make.trailing.equalToSuperview().inset(Constants.trailing)
            make.height.equalTo(Constants.refreshPageButtonHeight)
        }
    }
}
