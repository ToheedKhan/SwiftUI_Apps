//
//  PhotosClient.swift
//  PhotoGallery
//
//  Created by Toheed on 03/09/25.
//

import Foundation
import ComposableArchitecture

struct PhotosClient {
    var fetchPhotos: @Sendable () async throws -> [Photo]
}

extension PhotosClient: DependencyKey, TestDependencyKey {
    static let liveValue = PhotosClient(
        fetchPhotos: {
            let url = URL(string: "https://api.slingacademy.com/v1/sample-data/photos?offset=0&limit=20")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PhotosData.self, from: data)
            return decoded.photos
        }
    )
    
    static let testValue = PhotosClient(fetchPhotos: { [] })
}

extension DependencyValues {
    var photosClient: PhotosClient {
        get { self[PhotosClient.self] }
        set { self[PhotosClient.self] = newValue }
    }
}

