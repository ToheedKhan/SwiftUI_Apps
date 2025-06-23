//
//  APIService.swift
//  UserList
//
//  Created by Toheed Khan on 12/06/25.
//

import Foundation

// MARK: - Networking Layer

protocol APIServiceProtocol {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void)
}

class APIService: APIServiceProtocol {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, reponse, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
//                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
