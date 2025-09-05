//
//  Mocks.swift
//  PhotoGallery
//
//  Created by Toheed on 03/09/25.
//

import Foundation
import ComposableArchitecture

// MARK: - PhotosClient Mock
extension PhotosClient {
    static let mock = PhotosClient(
        fetchPhotos: {
            [
                Photo(id: 1, url: "test1.jpeg", title: "Mock Photo 1", description: "Mocked for Preview"),
                Photo(id: 2, url: "", title: "Mock Photo 2", description: "Another mock")
            ]
        }
    )
}

#if DEBUG
extension PhotosClient {
    static let mockWithLocal = PhotosClient(
        fetchPhotos: {
            [
                Photo(
                    id: 999,
                    url: "local:test1",   // special marker for asset
                    title: "Preview Local Photo",
                    description: "Loaded from Assets.xcassets"
                ),
                Photo(
                    id: 1000,
                    url: "https://api.slingacademy.com/public/sample-photos/15.jpeg",
                    title: "Remote Mock",
                    description: "Sample from mock API"
                )
            ]
        }
    )
}
#endif


// MARK: - UserDefaultsClient Mock
extension UserDefaultsClient {
    static let mock = UserDefaultsClient(
        set: { _, _ in },   // no-op for previews/tests
        get: { _ in "light" } // always return "light" for previews
    )
}
