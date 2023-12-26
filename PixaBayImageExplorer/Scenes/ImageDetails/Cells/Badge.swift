//
//  Badge.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit

class Badge: UIView {

    private let textLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: .M)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = .XS
        return stack
    }()

    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    public init(with model: Badge.ViewModel) {
        super.init(frame: .zero)
        setup()
        configure(with: model)
    }
    
    public func configure(with model: Badge.ViewModel) {
        configureText(text: model.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews()
        setUpUI()
        addConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setUpUI() {
        self.backgroundColor = .blue
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(.S)
    }
}

//MARK: Private functions
extension Badge {
    
    private func configureText(text: String) {
        textLabel.text = text
    }
    
    private func addSubviews() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(textLabel)
    }
    
    private func addConstraints() {
        contentStack.top(toView: self, constant: .XS)
        contentStack.bottom(toView: self, constant: .XS)
        contentStack.left(toView: self, constant: .S)
        contentStack.right(toView: self, constant: .S)
    }
}

extension Badge {
    public struct ViewModel {
        public let text: String
        
        public init(text: String) {
            self.text = text
        }
    }
}

