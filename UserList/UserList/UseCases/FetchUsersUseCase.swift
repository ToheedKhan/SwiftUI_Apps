//
//  FetchUsersUseCase.swift
//  UserList
//
//  Created by Toheed Khan on 01/07/25.
//

import Foundation

protocol FetchUsersUseCaseProtocol {
    func execute() async throws -> [User]
}

final class FetchUsersUseCase: FetchUsersUseCaseProtocol {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [User] {
        return try await repository.getUsers()
    }
}

// MARK: - Mock Use Case for Previews
final class MockFetchUsersUseCase: FetchUsersUseCaseProtocol {
    func execute() async throws -> [User] {
        return [
            User(id: 1, name: "John Doe", email: "john@example.com"),
            User(id: 2, name: "Jane Smith", email: "jane@example.com")
        ]
    }
}
