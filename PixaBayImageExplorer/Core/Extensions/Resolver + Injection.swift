//
//  Resolver + Injection.swift
//  PixaBayImageExplorer
//
//  Created by Sophio Kopaliani on 26/12/2023.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register(ImagesUseCase.self) { ImagesUseCaseImpl() }
        register(ImagesGateway.self) { ImagesGatewayImpl() }
        register(DataTransportService.self) { DataTransport() }
    }
}


