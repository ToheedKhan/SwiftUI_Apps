//
//  UserRepositoryTests.swift
//  UserListTests
//
//  Created by Toheed Khan on 02/07/25.
//

@testable import UserList
import XCTest

final class UserRepositoryTests: XCTestCase {

    final class MockUserService: UserServiceProtocol {
        var shouldThrow = false

        func fetchUsers() async throws -> [User] {
            if shouldThrow {
                throw NetworkError.serverError(statusCode: 500)
            }
            return [
                User(id: 1, name: "Test User", email: "test@example.com")
            ]
        }
    }

    var repository: UserRepository!

    func testRepositoryReturnsUsers() async throws {
        let mockService = MockUserService()
        repository = UserRepository(service: mockService)

        let users = try await repository.getUsers()
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "Test User")
    }

    func testRepositoryThrowsError() async {
        let mockService = MockUserService()
        mockService.shouldThrow = true
        repository = UserRepository(service: mockService)

        await XCTAssertThrowsErrorAsync (
            _ = try await self.repository.getUsers()
        )
    }
}
