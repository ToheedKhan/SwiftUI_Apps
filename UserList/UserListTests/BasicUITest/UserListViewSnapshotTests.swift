//
//  UserListViewSnapshotTests.swift
//  UserListTests
//
//  Created by Toheed Khan on 02/07/25.
//

/*
 Render UserListView with a mock ViewModel
 */

import XCTest
import SwiftUI
@testable import UserList

final class UserListViewSnapshotTests: XCTestCase {
    
    func testUserListView_withSuccessState() async throws {
        let mockUseCase = MockFetchUsersUseCase()
        mockUseCase.users = (1...3).map {
            User(id: $0, name: "User \($0)", email: "user\($0)@example.com")
        }
        
        let viewModel = await MainActor.run {
            UserListViewModel(fetchUsersUseCase: mockUseCase)
        }
        let view = await UserListView(viewModel: viewModel)
        
        let hosting = await UIHostingController(rootView: view)
        await MainActor.run {
            // Ensure the view is loaded on the main thread
            XCTAssertNotNil(hosting.view)
        }
    }
    
    func testUserListView_withEmptyState() async throws {
        let mockUseCase = MockFetchUsersUseCase()
        mockUseCase.users = []
        
        let viewModel = await MainActor.run {
            UserListViewModel(fetchUsersUseCase: mockUseCase, preload: false)
        }
        let view = await UserListView(viewModel: viewModel)
        
        let hosting = await UIHostingController(rootView: view)
        await MainActor.run {
            // Ensure the view is loaded on the main thread
            XCTAssertNotNil(hosting.view)
        }
    }
}

