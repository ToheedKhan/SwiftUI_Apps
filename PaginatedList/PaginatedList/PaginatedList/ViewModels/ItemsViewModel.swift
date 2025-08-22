//
//  ItemsViewModel.swift
//  PaginatedList
//
//  Created by Toheed on 14/08/25.
//

import SwiftUI

@MainActor

final class ItemsViewModel: ObservableObject {
    @Published private(set) var items: [Item] = []
    @Published private(set) var isLoadingPage = false
    @Published private(set) var isRefreshing = false
    @Published private(set) var errorMessage: String?
    
    private let api: ItemsAPI
    private let pageSize: Int
    private var currentPage: Int = 1
    private var canLoadMore = true
    
    init(
        api: ItemsAPI = MockItemsAPI(),
        pageSize: Int = 30
    ) {
        self.api = api
        self.pageSize = pageSize
    }
    
    func onAppear() {
        // Load first page if empty
        guard items.isEmpty else { return }
        Task {
            await loadNextPage()
        }
    }
    
    func refresh() {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        currentPage = 1
        canLoadMore = true
        errorMessage = nil
        
        Task {
            do {
                let freshItems = try await api.fetch(
                    page: 1,
                    pageSize: pageSize
                )
                
                items = freshItems
                currentPage = 2
                
            } catch {
                errorMessage = "Failed to refresh"
            }
            isRefreshing = false
        }
        
    }
    /*
     Benefits
     Avoids loading too early (wasting resources)
     
     Avoids loading too late (causing visible lag)
     
     Keeps the user experience smooth and responsive
     */
    func loadMoreIfNeeded(currentItem item: Item?) {
        guard let item = item else {
            
            //Called from onAppear of the List
            
            if items.isEmpty {
                Task {
                    await loadNextPage()
                }
            }
            return
        }
        // When the user scrolls to the last ~5 items, prefetch next page
        let thresholdIdx = max(items.count - 5, 0)
        if let idx = items.firstIndex(of: item), idx >= thresholdIdx {
            Task {
                await loadNextPage()
            }
        }
    }
    
    private func loadNextPage() async {
        guard !isLoadingPage, canLoadMore else { return }
        
        isLoadingPage = true
        errorMessage = nil
        let pageToLoad = currentPage
        
        do {
            let newItems = try await api.fetch(page: pageToLoad, pageSize: pageSize)
            
            if newItems.isEmpty {
                canLoadMore = false
            } else {
                // Append while avoiding duplicates (defensive)
                
                let existing = Set(items)
                let filtered = newItems.filter { !existing.contains($0) }
                
                items.append(contentsOf: filtered)
                currentPage += 1
            }
            
        } catch {
            errorMessage = "Failed to load page \(pageToLoad)."
        }
        
        isLoadingPage = false
    }
}


