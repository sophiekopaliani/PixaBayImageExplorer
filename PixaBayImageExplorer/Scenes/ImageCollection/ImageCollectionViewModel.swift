//
//  ImageCollectionViewModel.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation
import Resolver

protocol ImageCollectionViewModel {
    var images: [Image] { get }
    func fetchCharacters() async -> [Image]
    func getImage(by: Int) -> Image?
}

class ImageCollectionViewModelImpl: ImageCollectionViewModel {
    
    @Injected var uc: ImagesUseCase
    
    var images: [Image] = []
    var errorMessage: String = "" //TODO: delete if not using
    var hasError: Bool = false
    
    private var pageN = 0
    
    func fetchCharacters() async -> [Image] {
        do {
            pageN += 1
            let newImages = try await uc.getImages(for: pageN)
            images.append(contentsOf: newImages)
            return newImages
        } catch  {
            hasError = true
            errorMessage = (error as? ApiError)?.customDescription ?? error.localizedDescription
            return []
        }
    }
    
    func getImage(by index: Int) -> Image? {
        return images[index]
    }
}
