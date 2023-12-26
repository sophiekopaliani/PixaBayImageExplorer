//
//  ImageCell.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit
import SDWebImage

class ImageCell: UICollectionViewCell {
  static let identifier = String(describing: ImageCell.self)

  private let placeholderImage = UIImage(systemName: "photo.fill")?
    .withTintColor(.systemGray6, renderingMode: .alwaysOriginal)

  private let label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
      label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var productImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.image = placeholderImage
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
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
        contentView.addSubview(label)
        contentView.addSubview(productImageView)
    }
    
    private func setUpUI() {
        contentView.layer.borderColor = UIColor.systemBackground.cgColor
          contentView.layer.borderWidth = .XS2
    }
    
  private func addConstraints() {
      productImageView.top(toView: self)
      productImageView.left(toView: self)
      productImageView.right(toView: self)
      productImageView.bottom(toView: self, constant: .XL2)

      label.relativeTop(toView: productImageView)
      label.left(toView: self)
      label.right(toView: self)
      label.bottom(toView: self)
  }
    
    func configure(item: Image) {
        label.text = item.user
        productImageView.sd_setImage(with: item.fullSizeURL,
                                     placeholderImage: placeholderImage)
    }
}

