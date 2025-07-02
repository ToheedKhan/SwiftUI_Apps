//
//  UserServiceTests.swift
//  UserListTests
//
//  Created by Toheed Khan on 02/07/25.
//

import XCTest
@testable import UserList

final class UserServiceTests: XCTestCase {

    var service: UserService!

    override func setUpWithError() throws {
        service = UserService()
    }

    func testFetchUsersReturnsValidData() async throws {
        let users = try await service.fetchUsers()
        XCTAssertFalse(users.isEmpty, "Expected users to be returned from API.")
        XCTAssertNotNil(users.first?.name)
    }

    func testFetchUsersThrowsInvalidURLError() async {
        class BadURLService: UserServiceProtocol {
            func fetchUsers() async throws -> [User] {
                throw NetworkError.invalidURL
            }
        }

        let badService = BadURLService()

        await XCTAssertThrowsErrorAsync (
            _ = try await badService.fetchUsers() //Swift allows and often encourages the use of self inside escaping or asynchronous closures to be explicit.
        )
    }
}
