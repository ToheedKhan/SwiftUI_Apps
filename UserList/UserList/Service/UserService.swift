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
    case noInternet
    case timeout
    case serverError(statusCode: Int)
    case decodingFailed
    case requestFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .requestFailed:
            return "Network request failed."
        case .noInternet:
            return "No internet connection."
        case .timeout:
            return "The request timed out."
        case .serverError(let code):
            return "Server returned an error (status code: \(code))."
        case .decodingFailed:
            return "Failed to decode the response."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}

//enum NetworkError: Error, LocalizedError {
//    case invalidURL
//    case requestFailed
//    case decodingFailed
//    case serverError(statusCode: Int)
//
//    var errorDescription: String? {
//        switch self {
//        case .invalidURL:
//            return "The URL is invalid."
//        case .requestFailed:
//            return "Network request failed."
//        case .decodingFailed:
//            return "Failed to decode the response."
//        case .serverError(let code):
//            return "Server returned an error with status code: \(code)"
//        }
//    }
//}

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

//final class UserService: UserServiceProtocol {
//    func fetchUsers() async throws -> [User] {
//        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
//            throw NetworkError.invalidURL
//        }
//
//        let (data, response) = try await URLSession.shared.data(from: url)
//
//        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
//            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
//        }
//
//        do {
//            return try JSONDecoder().decode([User].self, from: data)
//        } catch {
//            throw NetworkError.decodingFailed
//        }
//    }
//}

final class UserService: UserServiceProtocol {
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            throw NetworkError.invalidURL
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: config)

        let maxAttempts = 3
        var attempt = 0
        var lastError: Error?

        while attempt < maxAttempts {
            do {
                let (data, response) = try await session.data(from: url)

                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }

                do {
                    return try JSONDecoder().decode([User].self, from: data)
                } catch {
                    throw NetworkError.decodingFailed
                }

            } catch let error as URLError {
                attempt += 1
                lastError = error

                switch error.code {
                case .notConnectedToInternet:
                    throw NetworkError.noInternet
                case .timedOut:
                    if attempt >= maxAttempts {
                        throw NetworkError.timeout
                    }
                default:
                    if attempt >= maxAttempts {
                        throw NetworkError.unknown(error)
                    }
                }

                try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * attempt)) // exponential backoff
            } catch {
                throw NetworkError.unknown(error)
            }
        }

        throw lastError ?? NetworkError.requestFailed
    }
}

