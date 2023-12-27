//
//  AuthorisationManagerUseCase.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 27/12/2023.
//

import Foundation
import Resolver

protocol AuthorisationManagerUseCase {
    func loginUser(email: String,
                   password: String)  async throws
    
    func registerUser(email: String,
                      password: String,
                      age: Int?)  async throws
}


class AuthorisationManagerUseCaseImpl: AuthorisationManagerUseCase {
    func loginUser(email: String,
                   password: String)  async throws {
        @Injected var userLoginGateway: UserLoginGateway
        do {
            let apiResponse = try await userLoginGateway.checkUserLoginInfo(for: email, and: password)
            guard email.lowercased() == apiResponse.email else { throw ValidatorError.emailDoesNotExist }
            guard password.lowercased() == apiResponse.password else { throw ValidatorError.passwordDoesNotMatch }
        } catch {
            throw error
        }
    }
    
    func registerUser(email: String,
                      password: String,
                      age: Int?) async throws {
        @Injected var userRegistrationGateway: UserRegistrationGateway
      
        do {
            let apiResponse = try await userRegistrationGateway.registerUser(with: email,
                                                                             password: password,
                                                                             age: age)
            guard email.lowercased() == apiResponse.email else { throw ValidatorError.emailDoesNotExist }
            guard password.lowercased() == apiResponse.password else { throw ValidatorError.passwordDoesNotMatch }
        } catch {
            throw error
        }
    }
}
