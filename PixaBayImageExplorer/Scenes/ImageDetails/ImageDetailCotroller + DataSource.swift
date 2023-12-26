//
//  ImageDetailCotroller + DataSource.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import UIKit

class ImageDetailsDataSource: UITableViewDiffableDataSource<ImageDetailsController.Section, Row> {
  
  init(tableView: UITableView) {
    super.init(tableView: tableView) { tableView, indexPath, item in
        switch item {
        case .imageWithDetails(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
            cell.configure(with: model)
            return cell
        case .tags(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.identifier, for: indexPath) as! TagsCell
            cell.configure(with: model)
            return cell
        case .detail(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.identifier, for: indexPath) as! DetailCell
            cell.configure(with: model)
            return cell
        }
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let header = ImageDetailsController.Section.allCases[section]
      switch header {
      case .inputs:
          return "picture"
      case .registration:
          return "details"
      }
  }
}
