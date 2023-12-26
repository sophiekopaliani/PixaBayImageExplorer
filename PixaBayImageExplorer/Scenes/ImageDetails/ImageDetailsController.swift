//
//  ImageDetailsController.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit

enum Row: Hashable {
    case imageWithDetails(Image?)
    case tags([String])
    case detail(ImageDetailsModel)
}

struct ImageDetailsModel: Hashable {
    let name: String
    let description: String
}

class ImageDetailsController: UIViewController {
    
    var vm: ImageDetailsViewModel
    
    lazy var imageRow = Row.imageWithDetails(vm.imageDetails)
    lazy var tagsRow = Row.tags(vm.tags)

    lazy var detailRows = vm.details.map { Row.detail($0) }
    
    init(vm: ImageDetailsViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dataSource = ImageDetailsDataSource(tableView: tableView)
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        updateDataSource()
    }
    
    private func setUp() {
        addSubviews()
        setUpUI()
        addConstraints()
        setupCollectionView()
    }
    
    private func  addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setUpUI() {
        navigationItem.title = "Image Details"
        self.view.backgroundColor = .systemBackground
    }
    
    private func addConstraints() {
        tableView.top(toView: self.view)
        tableView.bottom(toView: self.view)
        tableView.left(toView: self.view, constant: .M)
        tableView.right(toView: self.view, constant: .M)
    }
    
    private func setupCollectionView() {
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        tableView.register(TagsCell.self, forCellReuseIdentifier: TagsCell.identifier)
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.identifier)
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.inputs, .registration])
        snapshot.appendItems([imageRow, tagsRow], toSection: .inputs)
        snapshot.appendItems(detailRows, toSection: .registration)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    enum Section: CaseIterable {
        case inputs
        case registration
    }
}

