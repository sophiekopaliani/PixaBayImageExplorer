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
    var errorMessage: String? { get }
    func fetchCharacters() async -> [Image]
    func getImage(by: Int) -> Image?
}

class ImageCollectionViewModelImpl: ImageCollectionViewModel {
    
    @Injected var uc: ImagesUseCase
    
    var images: [Image] = []
    var errorMessage: String?
    
    private var pageN = 0
    
    func fetchCharacters() async -> [Image] {
        errorMessage = nil
        do {
            pageN += 1
            let newImages = try await uc.getImages(for: pageN)
            images.append(contentsOf: newImages)
            return newImages
        } catch  {
            errorMessage = (error as? ApiError)?.customDescription ?? error.localizedDescription
            return []
        }
    }
    
    func getImage(by index: Int) -> Image? {
        return images[index]
    }
}
