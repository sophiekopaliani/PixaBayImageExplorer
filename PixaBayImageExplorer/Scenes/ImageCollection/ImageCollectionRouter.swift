//
//  ImageCollectionRouter.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation

protocol ImageCollectionRouter {
    func navigateTo(item: Image)
}

extension ImageCollectionViewController: ImageCollectionRouter {
    func navigateTo(item: Image) { //TODO: move out
        let vm = ImageDetailsViewModelImpl(imageDetails: item)
        let vc = ImageDetailsController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
