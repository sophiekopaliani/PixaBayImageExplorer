//
//  ImageCollectionViewModel.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation
import Resolver

protocol ImageCollectionViewControllerProtocol: AnyObject {
    func reloadData()
}

protocol ImageCollectionViewModel {
    var delegate: ImageCollectionViewControllerProtocol? { get set }
    var images: [Image] { get }
    var errorMessage: String? { get }
    func fetchCharacters()
    func getImage(by: Int) -> Image?
}

class ImageCollectionViewModelImpl: ImageCollectionViewModel {
    
    @Injected var uc: ImagesUseCase
    
    weak var delegate: ImageCollectionViewControllerProtocol?
    
    var errorMessage: String?
    private var pageN = 0
    
    var images: [Image] = [] {
        didSet {
            Task {
                delegate?.reloadData()
            }
        }
    }
    
    @MainActor
    func fetchCharacters() {
        Task {
            errorMessage = nil
            do {
                pageN += 1
                let newImages = try await uc.getImages(for: pageN)
                images.append(contentsOf: newImages)
            } catch  {
                errorMessage = (error as? ApiError)?.customDescription ?? error.localizedDescription
            }
        }
    }
    
    func getImage(by index: Int) -> Image? {
        return images[index]
    }
}
