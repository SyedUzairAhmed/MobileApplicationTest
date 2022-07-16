//
//  TextFieldContentView.swift
//  DemoTest
//
//  Created by Syed Uzair Ahmed on 7/16/22.
//

import UIKit
import Combine

struct TextFieldContentConfiguration: UIContentConfiguration {
    var title: String? = nil
    var text: String? = nil
    var textChanged: ((String?) -> Void)?

    func makeContentView() -> UIView & UIContentView {
        return TextFieldContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> TextFieldContentConfiguration {
        return self
    }
}

class TextFieldContentView: UIView, UIContentView, UITextFieldDelegate {
    public var configuration: UIContentConfiguration {
        get {
            return appliedConfiguration
        }
        set {
            if let config = newValue as? TextFieldContentConfiguration {
                apply(configuration: config)
            }
        }
    }

    private var appliedConfiguration: TextFieldContentConfiguration = TextFieldContentConfiguration()

    private func apply(configuration: TextFieldContentConfiguration) {
        textField.text = configuration.text
        titleLabel.text = configuration.title
        self.appliedConfiguration = configuration
    }

    required init(configuration: TextFieldContentConfiguration) {
        textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        addViews()
        apply(configuration: configuration)

        textFieldToken = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main, using: { [weak self] notification in
            guard let textField = notification.object as? UITextField else {
                return
            }
            self?.appliedConfiguration.textChanged?(textField.text)
        })
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addViews() {
        textField.borderStyle = .roundedRect
        addSubview(textField)
        addSubview(titleLabel)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: guide.topAnchor),
            textField.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            textField.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private let titleLabel: UILabel
    private let textField: UITextField
    private var textFieldToken: Any?
}
