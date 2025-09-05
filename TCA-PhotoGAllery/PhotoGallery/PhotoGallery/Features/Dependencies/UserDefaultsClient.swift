//
//  UserDefaultsClient.swift
//  PhotoGallery
//
//  Created by Toheed on 03/09/25.
//

import Foundation
import ComposableArchitecture

struct UserDefaultsClient {
    var set: @Sendable (String, String) -> Void
    var get: @Sendable (String) -> String?
}

extension UserDefaultsClient: DependencyKey, TestDependencyKey {
    static let liveValue = UserDefaultsClient(
        set: { key, value in UserDefaults.standard.set(value, forKey: key) },
        get: { key in UserDefaults.standard.string(forKey: key) }
    )
    
    static let testValue = UserDefaultsClient(
        set: { _, _ in },
        get: { _ in "automatic" }
    )
}

extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
