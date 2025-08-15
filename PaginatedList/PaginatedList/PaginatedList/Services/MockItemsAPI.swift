//
//  MockItemsAPI.swift
//  PaginatedList
//
//  Created by Toheed on 14/08/25.
//

import Foundation

protocol ItemsAPI {
    func fetch(page: Int, pageSize: Int) async throws -> [Item]
}

struct MockItemsAPI: ItemsAPI {
    /// Simulates a 1000-item backend with pagination.
    func fetch(page: Int, pageSize: Int) async throws -> [Item] {
        // Simulate network latency (non-blocking)
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        let total = 1000
        
        let start = (page - 1) * pageSize
        
        guard start < total else { return [] }
        
        let end = min(start + pageSize, total)
        
        return (start..<end).map { idx in
            Item(id: idx + 1, title: "Item \((idx + 1))")
        }
    }
}
