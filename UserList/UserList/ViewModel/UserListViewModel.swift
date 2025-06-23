//
//  UserListViewModel.swift
//  UserList
//
//  Created by Toheed Khan on 12/06/25.
//

// MARK: - ViewModel

import Foundation

class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService())
    {
        self.apiService = apiService
        fetchUsers()
    }
    
    func fetchUsers()
    {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription 
                }
            }
        }
    }
}
