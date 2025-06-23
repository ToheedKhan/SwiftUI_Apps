//
//  User.swift
//  UserList
//
//  Created by Toheed Khan on 12/06/25.
//

// MARK: - Models

struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
}
