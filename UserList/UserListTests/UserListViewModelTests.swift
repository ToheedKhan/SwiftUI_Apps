//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Toheed Khan on 02/07/25.
//

import XCTest
@testable import UserList

final class UserListViewModelTests: XCTestCase {

    var viewModel: UserListViewModel!
    var mockUseCase: MockFetchUsersUseCase!

//    override func setUp() async {
//        super.setUp()
//        mockUseCase = MockFetchUsersUseCase()
//        viewModel = await MainActor.run {
//            UserListViewModel(fetchUsersUseCase: mockUseCase)
//        }
//    }
    
//    override func setUpWithError() throws {
//        mockUseCase = MockFetchUsersUseCase()
//    }
    //OR
    override func setUp() async throws {
        mockUseCase = MockFetchUsersUseCase()
        viewModel = await MainActor.run {
            UserListViewModel(fetchUsersUseCase: mockUseCase)
        }
    }


    func testFetchUsersSuccess() async {
        // Given
        mockUseCase.users = (1...10).map {
            UserList.User(id: $0, name: "User \($0)", email: "user\($0)@example.com")
        }

        // When
        await viewModel.fetchUsers()

        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.users.count, 5)
            XCTAssertNil(viewModel.errorMessage)
        }

    }

    func testFetchUsersFailure() async {
        // Given
        mockUseCase.shouldFail = true

        // When
        await viewModel.fetchUsers()

        // Then
        await MainActor.run {
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertTrue(viewModel.users.isEmpty)
        }
    }

    func testRefreshUsers() async {
        // Given
        mockUseCase.users = (1...20).map {
            User(id: $0, name: "User \($0)", email: "user\($0)@example.com")
        }

        // When
        await viewModel.refreshUsers()

        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.users.count, 5)
        }
    }

    func testLoadMoreUsersIfNeeded() async {
        // Given
        mockUseCase.users = (1...20).map {
            User(id: $0, name: "User \($0)", email: "user\($0)@example.com")
        }
        await viewModel.fetchUsers()

        // When
        if let lastUser = await viewModel.users.last {
            await viewModel.loadMoreUsersIfNeeded(currentUser: lastUser)
        }

        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.users.count, 10)
        }
    }

    func testSaveAndLoadCachedUsers() async {
        let testUsers = (1...10).map {
            User(id: $0, name: "Cached \($0)", email: "cached\($0)@example.com")
        }

        viewModel = await MainActor.run {
            UserListViewModel(fetchUsersUseCase: mockUseCase)
        }

        await MainActor.run {
            viewModel.saveUsersToCache(testUsers)
            viewModel.users = []
            viewModel.loadCachedUsers()

            XCTAssertEqual(viewModel.users.count, 5)
            XCTAssertEqual(viewModel.users.first?.name, "Cached 1")
        }
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        mockUseCase = nil
    }
}
