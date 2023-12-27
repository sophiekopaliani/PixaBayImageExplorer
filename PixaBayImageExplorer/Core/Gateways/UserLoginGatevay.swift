//
//  UserLoginGatevay.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation

protocol UserLoginGateway {
    func checkUserLoginInfo(for email: String?, and password: String?) async throws -> ApiUserInfo
}

class MockUserLoginGatewayImpl: UserLoginGateway {
    func checkUserLoginInfo(for email: String?, and password: String?) async throws -> ApiUserInfo {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        guard email?.lowercased() != "sophie.kopaliani@gmail.com" else {
            return .init(email: "sophie.kopaliani@gmail.com", age: 70) }
        guard email?.lowercased() != "testuser@gmail.com" else {
            return .init(email: "testuser@gmail.com", age: 18)}
        guard email?.lowercased() != "showerror@gmail.com" else {
            throw ValidatorError.cannotLogin
        }
        return .init(email: "testuser@gmail.com", age: 18)
    }
}
