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
    @Published var isPaginating = false
    @Published var errorMessage: String?

    private let fetchUsersUseCase: FetchUsersUseCaseProtocol
    private var currentPage = 1
    private let itemsPerPage = 5
    
    private let cacheFile = "cached_users.json"
    
//To make the mock data appear instantly in preview (without .task):
    init(fetchUsersUseCase: FetchUsersUseCaseProtocol, preload: Bool = false) {
        self.fetchUsersUseCase = fetchUsersUseCase
        if preload {
            Task {
                loadCachedUsers()        // ✅ Load from cache first
                await fetchUsers()       // 🔄 Then fetch latest from server
            }
        }
    }

    func fetchUsers() async {
        isLoading = true
        do {
            let allUsers = try await fetchUsersUseCase.execute()
            self.users = Array(allUsers.prefix(itemsPerPage))
            self.currentPage = 1
            saveUsersToCache(allUsers)   // ✅ Save to cache
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func refreshUsers() async {
        do {
            let allUsers = try await fetchUsersUseCase.execute()
            self.users = Array(allUsers.prefix(itemsPerPage))
            self.currentPage = 1
            saveUsersToCache(allUsers)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadMoreUsersIfNeeded(currentUser: User) async {
        guard !isPaginating, let lastUser = users.last, lastUser.id == currentUser.id else { return }

        isPaginating = true
        do {
            let allUsers = try await fetchUsersUseCase.execute()
            let nextPage = currentPage + 1
            let newUsers = Array(allUsers.prefix(nextPage * itemsPerPage))
            if newUsers.count > users.count {
                users = newUsers
                currentPage = nextPage
                saveUsersToCache(allUsers)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isPaginating = false
    }
    
    // MARK: - Offline Caching

        private func cacheURL() -> URL? {
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(cacheFile)
        }

        func saveUsersToCache(_ users: [User]) {
            guard let url = cacheURL() else { return }
            do {
                let data = try JSONEncoder().encode(users)
                try data.write(to: url)
            } catch {
                print("❌ Failed to save cache: \\(error)")
            }
        }

        func loadCachedUsers() {
            guard let url = cacheURL(), let data = try? Data(contentsOf: url) else { return }
            do {
                let cachedUsers = try JSONDecoder().decode([User].self, from: data)
                self.users = Array(cachedUsers.prefix(itemsPerPage))
            } catch {
                print("❌ Failed to load cached users: \\(error)")
            }
        }
}
