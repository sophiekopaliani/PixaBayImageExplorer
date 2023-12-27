//
//  AuthorisationManagerUseCase.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation

protocol AuthorisationManagerUseCase {
    func loginUser(email: String,
                   password: String)  async throws
    
    func registerUser(email: String,
                      password: String,
                      age: Int?)  async throws -> Bool //TODO: 
}


class AuthorisationManagerUseCaseImpl: AuthorisationManagerUseCase {
    func loginUser(email: String,
                   password: String)  async throws {
        let userLoginGateway = MockUserLoginGatewayImpl()
        do {
            let apiResponse = try await userLoginGateway.checkUserLoginInfo(for: email, and: password)
            guard email == apiResponse.email else { throw ValidatorError.emailDoesNotExist }
            guard password == apiResponse.password else { throw ValidatorError.passwordDoesNotMatch }
        } catch {
            throw error
        }
    }
    
    @discardableResult
    func registerUser(email: String,
                      password: String,
                      age: Int?) async throws -> Bool {
        let userRegistrationGateway = MockUserRegistrationGatewayImpl()
        do {
            let apiResponse = try await userRegistrationGateway.registerUser(with: email,
                                                                             password: password,
                                                                             age: age)
            return email == apiResponse.email
        } catch {
            throw error
        }
    }
}
