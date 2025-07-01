//
//  UserRepository.swift
//  UserList
//
//  Created by Toheed Khan on 01/07/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func getUsers() async throws -> [User]
}

final class UserRepository: UserRepositoryProtocol {
    private let service: UserServiceProtocol

    init(service: UserServiceProtocol) {
        self.service = service
    }

    func getUsers() async throws -> [User] {
        return try await service.fetchUsers()
    }
}
