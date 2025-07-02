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
            List {
                if viewModel.isLoading && viewModel.users.isEmpty {
                    ProgressView("Loading...")
                } else {
                    ForEach(viewModel.users) { user in
                        VStack(alignment: .leading) {
                            Text(user.name).font(.headline)
                            Text(user.email).font(.subheadline).foregroundColor(.gray)
                        }
                    }
                }

                if viewModel.isPaginating {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .refreshable {
                await viewModel.refreshUsers()
            }
            .onAppear {
                if viewModel.users.isEmpty {
                    Task { await viewModel.fetchUsers() }
                }
            }
            .onAppear {
                UITableView.appearance().keyboardDismissMode = .onDrag
            }
            .navigationTitle("Users")
        }
    }
}

// MARK: - Previews
struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockUseCase = MockFetchUsersUseCase()
        let viewModel = UserListViewModel(fetchUsersUseCase: mockUseCase, preload: true)
        return UserListView(viewModel: viewModel)
    }
}

