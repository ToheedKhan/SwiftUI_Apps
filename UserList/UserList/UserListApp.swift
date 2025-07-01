//
//  UserListApp.swift
//  UserList
//
//  Created by Toheed Khan on 12/06/25.
//

import SwiftUI

@main
struct UserListApp: App {
    var body: some Scene {
        WindowGroup {
            let service = UserService()
            let repository = UserRepository(service: service)
            let useCase = FetchUsersUseCase(repository: repository)
            let viewModel = UserListViewModel(fetchUsersUseCase: useCase)
            UserListView(viewModel: viewModel)
        }
    }
}
