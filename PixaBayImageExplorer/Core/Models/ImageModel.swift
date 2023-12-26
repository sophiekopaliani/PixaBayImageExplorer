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
    let userImageURL: URL?
    let previewURL: URL?
    let fullSizeURL: URL?
    
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
        self.userImageURL = URL(string: api.userImageURL ?? "")
        self.previewURL = URL(string: api.imageURL ?? api.previewURL ?? "")
        self.fullSizeURL = URL(string: api.largeImageURL ?? api.previewURL ?? "" )
    }
}
