//
//  AuthenticationRouter.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation

protocol AuthernticationRouter {
    func navigateToMainPage()
    func navigateToRegistrationPage()
}

extension AuthenticationController: AuthernticationRouter {
    func navigateToMainPage() {
        let vm = ImageCollectionViewModelImpl()
        let vc = ImageCollectionViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToRegistrationPage() {
        let vc = RegistrationController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
