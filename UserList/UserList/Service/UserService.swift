//
//  UserService.swift
//  UserList
//
//  Created by Toheed Khan on 12/06/25.
//

import Foundation

// MARK: - Networking Layer

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed
    case decodingFailed
    case serverError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed:
            return "Network request failed."
        case .decodingFailed:
            return "Failed to decode the response."
        case .serverError(let code):
            return "Server returned an error with status code: \(code)"
        }
    }
}

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
}

//final class UserService: UserServiceProtocol {
//    func fetchUsers() async throws -> [User] {
//        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
//        let (data, _) = try await URLSession.shared.data(from: url)
//        return try JSONDecoder().decode([User].self, from: data)
//    }
//}

final class UserService: UserServiceProtocol {
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
