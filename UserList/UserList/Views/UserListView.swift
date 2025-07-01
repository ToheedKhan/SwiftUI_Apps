//
//  UserListView.swift
//  UserList
//
//  Created by Toheed Khan on 12/06/25.
//

// MARK: - Views

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel
    
    init(viewModel: UserListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading ...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error : \(errorMessage)").foregroundColor(.red)
                } else {
                    List(viewModel.users) { user in
                        VStack(alignment: .leading) {
                            Text(user.name).font(.headline)
                            Text(user.email).font(.subheadline).foregroundColor(.gray)
                        }
//                        Text("\(user.name) (\(user.email))")
                    }
                }
            }
            .navigationTitle("Users")
        }
        .task {
            await viewModel.fetchUsers()
        }
    }
}

// MARK: - Previews
struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUseCase = MockFetchUsersUseCase()
        let viewModel = UserListViewModel(fetchUsersUseCase: mockUseCase)
        return UserListView(viewModel: viewModel)
    }
}
