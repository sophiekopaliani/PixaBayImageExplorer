//
//  ApiUserInfo.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation

struct ApiUserInfo: Codable {
    let email: String?
    var password: String? = "password"
    let age: Int?
}
