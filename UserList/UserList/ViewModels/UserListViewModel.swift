//
//  UserListViewModel.swift
//  UserList
//
//  Created by Toheed Khan on 12/06/25.
//

// MARK: - ViewModel

import Foundation

@MainActor
final class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let fetchUsersUseCase: FetchUsersUseCaseProtocol

    init(fetchUsersUseCase: FetchUsersUseCaseProtocol) {
        self.fetchUsersUseCase = fetchUsersUseCase
    }

    func fetchUsers() async {
        isLoading = true
        do {
            users = try await fetchUsersUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
