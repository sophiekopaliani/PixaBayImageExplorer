//
//  ImageCollectionController.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit
import NotificationBannerSwift

class ImageCollectionViewController: UICollectionViewController {
    
    var vm: ImageCollectionViewModel
    
    init(vm: ImageCollectionViewModel) {
        self.vm = vm
        super.init(collectionViewLayout: .init())
        self.vm.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Section: Int, CaseIterable {
        case grid
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Image>?
    private var layout: UICollectionViewCompositionalLayout?
    
    private var images: [Image] { vm.images }
    private var isPaginating = true
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataSource()
        vm.fetchCharacters()
    }
    
    private func setup() {
        setUpUI()
        setupDataSource()
        setupCompositionalLayout()
        setupCollectionView()
    }

    private func setUpUI() {
        navigationItem.title = "Images"
    }
    
    private func setupCollectionView() {
        guard let layout else { return }
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(FooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterView.identifier)
        collectionView.collectionViewLayout = layout
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .grid:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ImageCell.identifier,
                    for: indexPath) as! ImageCell
                cell.configure(item: item)
                return cell
            }
        }
        
        dataSource?.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            guard let footerView = self.collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: FooterView.identifier, for: indexPath) as? FooterView else { fatalError() }
            footerView.toggleLoading(isEnabled: isPaginating)
            return footerView
        }
    }

    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Image>()
        snapshot.appendSections([.grid])
        snapshot.appendItems(images, toSection: .grid)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func showErrorMessage(message: String?) {
        guard let message = message else { return }
        let banner = FloatingNotificationBanner(title: message,
                                                style: .danger)
        banner.show(edgeInsets: .init(top: .L, left: .M, bottom: .zero, right: .M),
                    cornerRadius: .S)
    }
}

extension ImageCollectionViewController: ImageCollectionViewControllerProtocol {
    func reloadData() {
        self.isPaginating = false
        updateDataSource()
    }
}

//MARK: Layout
extension ImageCollectionViewController {
    private func setupCompositionalLayout() {
        layout = .init(sectionProvider: { sectionIndex, env in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .grid:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(.XS3), heightDimension: .fractionalHeight(.XS2)))
                item.contentInsets = .init(top: .XS, leading: .XS, bottom: .XS, trailing: .XS)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(.XS2), heightDimension: .fractionalHeight(.XS4)), subitems: [item])
                group.contentInsets = .init(top: .XS, leading: .XS, bottom: .XS, trailing: .XS)
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [self.getFooter()]
                return section
            }
        })
    }
    
    private func getFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(.XS2), heightDimension: .absolute(.XL6))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        return footer
    }
}

//MARK: DataSource
extension ImageCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == images.count - 1 {
            isPaginating = true
            vm.fetchCharacters()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = vm.getImage(by: indexPath.row) else { return }
        navigateTo(item: image)
    }
}
