//
//  ImagesUseCase.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation
import Resolver

protocol ImagesUseCase {
    func getImages(for page: Int) async throws -> [Image]
}

class ImagesUseCaseImpl: ImagesUseCase {
    
    @Injected var imagesGateway: ImagesGateway

    let itemPerPage = 10
    
    func getImages(for pageN: Int = 1) async throws -> [Image] {
        do {
            let apiImages = try await imagesGateway.fetchImages(for: pageN, itemPerPage: itemPerPage)
            return apiImages.hits.compactMap{ Image(with: $0) }
        } catch {
            throw error
        }
    }
}
