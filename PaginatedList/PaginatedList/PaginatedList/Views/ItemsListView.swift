//
//  ItemListView.swift
//  PaginatedList
//
//  Created by Toheed on 14/08/25.
//

import SwiftUI

import SwiftUI

struct ItemsListView: View {
    @StateObject private var viewModel = ItemsViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.items.isEmpty && viewModel.isLoadingPage {
                    // First-load spinner
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            Text(item.title)
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(currentItem: item)
                                }
                        }
                        
                        // Loading footer during pagination
                        if viewModel.isLoadingPage {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable {
                        viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Paginated Items")
            .onAppear { viewModel.onAppear() }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text(viewModel.errorMessage ?? "")
            })
        }
    }
}


#Preview {
    ItemsListView()
}
