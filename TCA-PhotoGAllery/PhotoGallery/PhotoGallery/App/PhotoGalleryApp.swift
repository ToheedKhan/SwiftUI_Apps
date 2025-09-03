//
//  PhotoGalleryApp.swift
//  PhotoGallery
//
//  Created by Toheed on 31/08/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct PhotoGalleryApp: App {
    var body: some Scene {
        WindowGroup {
            PhotoListView(
                store: Store(
                    initialState: PhotoListReducer.State(),
                    reducer: {
                        PhotoListReducer(
                            photosClient: .live,
                            userDefaultsClient: .live
                        )
                    }
                )
            )
        }
    }
}

