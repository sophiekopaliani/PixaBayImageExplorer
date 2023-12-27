//
//  UserRegistrationGateway.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation

protocol UserRegistrationGateway {
    func registerUser(with email: String, password: String, age: Int?) async throws -> ApiUserInfo
}

class MockUserRegistrationGatewayImpl: UserRegistrationGateway {
    
    func registerUser(with email: String, password: String, age: Int?) async throws -> ApiUserInfo {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        guard email.lowercased() != "sophie.kopaliani@gmail.com" else {
            return .init(email: "sophie.kopaliani@gmail.com", age: 70) }
        guard email.lowercased() != "testuser@gmail.com" else {
            return .init(email: "testuser@gmail.com", age: 18)}
        return .init(email: "testuser@gmail.com", age: 18)
    }
}
