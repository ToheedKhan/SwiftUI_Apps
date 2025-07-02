//
//  MockFetchUsersUseCase.swift
//  UserListTests
//
//  Created by Toheed Khan on 02/07/25.
//

@testable import UserList

final class MockFetchUsersUseCase: FetchUsersUseCaseProtocol {
  
    var shouldFail = false
    var users: [User] = []

    func execute() async throws -> [User] {
        if shouldFail {
            throw NetworkError.serverError(statusCode: 500)
        }
        return users
    }
}
