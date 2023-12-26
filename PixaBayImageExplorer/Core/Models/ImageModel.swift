//
//  ImageModel.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation

struct Image: Hashable {
    let id: Int
    let type: ImageType
    let tags: [String]
    let imageSize: Int
    let views: Int
    let likes: Int
    let user: String
    let comments: Int
    let downloads: Int
    let userImageURL: String?
    let previewURL: String?
    let fullSizeURL: String?
    
    enum ImageType: String {
        case photo
        case illustration
        case vector
        case all
        case none
    }
}

extension Image {
    init?(with api: ApiImage) {
        guard let id = api.id
        else { return nil }
        self.id = id
        self.type = ImageType(rawValue: api.type ?? "") ?? .none
        self.tags = api.tags?.components(separatedBy: ", ") ?? []
        self.imageSize = api.imageSize ?? 0
        self.views = api.views ?? 0
        self.likes = api.likes ?? 0
        self.user = api.user ?? "Unknown"
        self.comments = api.comments ?? 0
        self.downloads = api.downloads ?? 0
        self.userImageURL = api.userImageURL
        self.previewURL = api.imageURL ?? api.previewURL
        self.fullSizeURL = api.largeImageURL ?? self.previewURL
    }
}
