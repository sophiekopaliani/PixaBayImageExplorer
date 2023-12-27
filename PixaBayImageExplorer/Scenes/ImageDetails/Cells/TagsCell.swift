//
//  TagsCell.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit

class TagsCell: UITableViewCell, UIScrollViewDelegate {
    static let identifier = String(describing: TagsCell.self)
    
    private let badge: Badge = {
        let b = Badge()
        return b
    }()
    
    private lazy var badgeContainerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = .M
        return stackView
    }()
    
    private lazy var contentContainerView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        addSubviews()
        self.backgroundColor = .clear
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(contentContainerView)
        contentContainerView.addSubview(badgeContainerStack)
    }
    
    
    private func addConstraints() {
        contentContainerView.top(toView: contentView, constant: .M)
        contentContainerView.bottom(toView: contentView, constant: .M)
        contentContainerView.left(toView: contentView, constant: .M)
        contentContainerView.right(toView: contentView, constant: .M)
        contentContainerView.delegate = self
        
        badgeContainerStack.top(toView: contentContainerView)
        badgeContainerStack.bottom(toView: contentContainerView)
        badgeContainerStack.left(toView: contentContainerView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("sophieeeeee")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tags: [String]) {
        badgeContainerStack.removeAllArrangedSubviews()
        for tag in tags {
            badgeContainerStack.addArrangedSubview(Badge(with: .init(text: tag)))
            badgeContainerStack.addArrangedSubview(Badge(with: .init(text: tag)))
            badgeContainerStack.addArrangedSubview(Badge(with: .init(text: tag)))
        }
    }
    
}

