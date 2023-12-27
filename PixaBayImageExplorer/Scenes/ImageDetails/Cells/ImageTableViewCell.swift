//
//  ImageTableViewCell.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit
import SDWebImage

class ImageTableViewCell: UITableViewCell {
    static let identifier = String(describing: ImageTableViewCell.self)

    private let placeholderImage = UIImage(systemName: "photo.fill")?
        .withTintColor(.systemGray6, renderingMode: .alwaysOriginal)

    private let imageSizeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: .M)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: .M)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = placeholderImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        setUpUI()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(productImageView)
        contentView.addSubview(imageSizeLabel)
        contentView.addSubview(imageTypeLabel)
    }
    
    private func setUpUI() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    private func addConstraints() {
        productImageView.top(toView: contentView)
        productImageView.left(toView: contentView)
        productImageView.right(toView: contentView)
        productImageView.height(equalTo: 400)

        imageSizeLabel.relativeTop(toView: productImageView, constant: .S)
        imageSizeLabel.left(toView: contentView)
        imageSizeLabel.right(toView: contentView)

        imageTypeLabel.relativeTop(toView: imageSizeLabel, constant: .XS)
        imageTypeLabel.left(toView: contentView)
        imageTypeLabel.right(toView: contentView)
        imageTypeLabel.bottom(toView: contentView)
    }
    
    func configure(with item: Image?) {
        guard let item else { return }
        imageSizeLabel.text = "Size: \(item.imageSize)"
        imageTypeLabel.text = "Type: \(item.type.rawValue)"
        productImageView.sd_setImage(with: item.fullSizeURL,
                                     placeholderImage: placeholderImage)
    }
}
