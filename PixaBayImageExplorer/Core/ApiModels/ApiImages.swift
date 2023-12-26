//
//  ApiImages.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation

struct ApiImages: Codable {
    let hits: [ApiImage]
}

struct ApiImage: Codable {
    let id: Int?
    let type: String?
    let tags: String?
    let imageSize: Int?
    let views: Int?
    let likes: Int?
    let user: String?
    let comments: Int?
    let downloads: Int?
    let userImageURL: String?
    let imageURL: String?
    let previewURL: String?
    let largeImageURL: String?
}
