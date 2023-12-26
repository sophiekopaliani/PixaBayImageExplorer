//
//  ImagesGateway.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation
import Resolver

protocol ImagesGateway {
    func fetchImages(for page: Int, itemPerPage: Int?) async throws -> ApiImages
}

class ImagesGatewayImpl: ImagesGateway {
    
    @Injected var dataTransport: DataTransportService

    let scheme = "https"
    let host = "pixabay.com"
    let path =  "/api/"
    let apiKey = "41453795-e4e79236bee8c10b37d2193ff"

    lazy var apiKeyQuery = URLQueryItem(name: "key", value: apiKey)
    
    func fetchImages(for pageN: Int, itemPerPage: Int?) async throws -> ApiImages {
        var queryParams = [apiKeyQuery]
        queryParams.append(.init(name: "page", value: "\(pageN)"))
        if let itemPerPage {
            queryParams.append(.init(name: "per_page", value: "\(itemPerPage)"))
        }
        let endpoint = Endpoint(scheme: scheme, host: host, path: path, queryItems: queryParams)
        guard let url = endpoint.url else {
            throw ApiError.couldNotCreateRequest
        }
        let request = URLRequest(url: url)
        return try await dataTransport.fetch(type: ApiImages.self, with: request)
    }
}
