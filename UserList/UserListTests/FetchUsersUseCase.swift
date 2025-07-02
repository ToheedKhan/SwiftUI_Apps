//
//  FetchUsersUseCase.swift
//  UserListTests
//
//  Created by Toheed Khan on 02/07/25.
//

@testable import UserList
import XCTest

final class FetchUsersUseCaseTests: XCTestCase {

    final class MockUserRepository: UserRepositoryProtocol {
        var shouldThrow = false

        func getUsers() async throws -> [User] {
            if shouldThrow {
                throw NetworkError.timeout
            }
            return [User(id: 1, name: "Repo User", email: "repo@example.com")]
        }
    }

    var useCase: FetchUsersUseCase!

    func testUseCaseReturnsUsers() async throws {
        let mockRepo = MockUserRepository()
        useCase = FetchUsersUseCase(repository: mockRepo)

        let users = try await useCase.execute()
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "Repo User")
    }

    func testUseCaseThrowsError() async {
        let mockRepo = MockUserRepository()
        mockRepo.shouldThrow = true
        useCase = FetchUsersUseCase(repository: mockRepo)

        await XCTAssertThrowsErrorAsync (
            _ = try await self.useCase.execute()
         )
//        await XCTAssertThrowsErrorAsync(try await self.useCase.execute())


    }
}
