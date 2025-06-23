//
//  UserListView.swift
//  UserList
//
//  Created by Toheed Khan on 12/06/25.
//

// MARK: - Views

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    
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
    }
}

 // MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}

