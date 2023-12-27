//
//  RegistrationRouter.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation

extension RegistrationController {
    func navigateToMainPage() {
        let vm = ImageCollectionViewModelImpl()
        let vc = ImageCollectionViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
