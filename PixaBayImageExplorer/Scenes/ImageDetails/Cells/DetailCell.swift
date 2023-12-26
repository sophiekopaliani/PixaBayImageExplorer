//
//  DetailCell.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit

class DetailCell: UITableViewCell {
    static let identifier = String(describing: DetailCell.self)
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: .L)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: .L)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = .XS
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubviews()
        self.backgroundColor = .clear
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func addConstraints() {
        labelsStackView.top(toView: self)
        labelsStackView.bottom(toView: self)
        labelsStackView.left(toView: self)
        labelsStackView.right(toView: self)
    }

    func configure(with model: ImageDetailsModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
    }
}
