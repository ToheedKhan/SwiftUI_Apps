//
//  AppPreviews.swift
//  PhotoGallery
//
//  Created by Toheed on 01/09/25.
//

import SwiftUI
import ComposableArchitecture

struct AppPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // PhotoListView Light
            PhotoListView(
                store: Store(
                    initialState: PhotoListReducer.State(
                        photos: [
                            Photo(id: 1, url: "", title: "Sample 1", description: "Desc 1"),
                            Photo(id: 2, url: "", title: "Sample 2", description: "Desc 2")
                        ],
                        isLoading: false,
                        themeMode: .light
                    ),
                    reducer: {
                        PhotoListReducer(
                        photosClient: .test,
                        userDefaultsClient: .test
                     )
                    }
                )
            )
            .previewDisplayName("📸 Photo List (Light)")
            .preferredColorScheme(.light)
            
            // PhotoListView Dark
            PhotoListView(
                store: Store(
                    initialState: PhotoListReducer.State(
                        photos: [
                            Photo(id: 1, url: "", title: "Sample 1", description: "Desc 1"),
                            Photo(id: 2, url: "", title: "Sample 2", description: "Desc 2")
                        ],
                        isLoading: false,
                        themeMode: .dark
                    ),
                    reducer: {
                        PhotoListReducer(
                            photosClient: .test,
                            userDefaultsClient: .test
                        )
                    }
                )
            )
            .previewDisplayName("📸 Photo List (Dark)")
            .preferredColorScheme(.dark)
            
            // SettingsView Light
            NavigationStack {
                SettingsView(
                    store: Store(
                        initialState: PhotoListReducer.State(themeMode: .light),
                        reducer: {
                            PhotoListReducer(
                                photosClient: .test,
                                userDefaultsClient: .test
                            )
                        }
                    )
                )
            }
            .previewDisplayName("⚙️ Settings (Light)")
            .preferredColorScheme(.light)
            
            // SettingsView Dark
            NavigationStack {
                SettingsView(
                    store: Store(
                        initialState: PhotoListReducer.State(themeMode: .dark),
                        reducer: {
                            PhotoListReducer(
                                photosClient: .test,
                                userDefaultsClient: .test
                            )
                        }
                    )
                )
            }
            .previewDisplayName("⚙️ Settings (Dark)")
            .preferredColorScheme(.dark)
        }
    }
}
