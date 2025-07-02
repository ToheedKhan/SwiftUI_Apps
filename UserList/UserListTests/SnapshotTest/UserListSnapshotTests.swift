//
//  UserListSnapshotTests.swift
//  UserListTests
//
//  Created by Toheed Khan on 02/07/25.
//

import SnapshotTesting
import XCTest
import SwiftUI
@testable import UserList

final class UserListSnapshotTests: XCTestCase {
    
    func testUserListSnapshot_withUsers() async {
        let mockUseCase = MockFetchUsersUseCase()
        mockUseCase.users = [
            User(id: 1, name: "Test User", email: "test@example.com")
        ]
        let viewModel = await MainActor.run {
            UserListViewModel(fetchUsersUseCase: mockUseCase)
        }
        let view = await UserListView(viewModel: viewModel)
        let host = await UIHostingController(rootView: view)
        
        await MainActor.run {
            assertSnapshot(of: host, as: .image(on: .iPhone13))
        }
    }
}
