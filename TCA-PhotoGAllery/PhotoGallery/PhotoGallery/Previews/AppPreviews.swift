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
            //PhotoListView Light
            
            PhotoListView(
                store: Store(initialState: PhotoListReducer.State(), reducer: {
                    PhotoListReducer()
                }) {
                    $0.photosClient = .mockWithLocal
                    $0.userDefaultsClient = .mock
                }
            ) .previewDisplayName("Photo List (mock)")
                .preferredColorScheme(.light)
            
            
            PhotoListView(
                store: Store(
                    initialState: PhotoListReducer.State(),
                    reducer: {
                        PhotoListReducer()
                    },
                    withDependencies: { deps in
                        deps.photosClient = .mock
                        deps.userDefaultsClient = .mock
                    }
                )
            ).previewDisplayName("Photo List (mock - Dark)")
                .preferredColorScheme(.dark)
            
            
            // SettingsView Light
            
            NavigationStack {
                SettingsView(
                    store: Store(
                        initialState: PhotoListReducer.State(themeMode: .light),
                        reducer: {
                            PhotoListReducer()
                        }
                    ) {
                        $0.userDefaultsClient = .testValue
                    }
                )
            }.previewDisplayName(" Settings (Light)")
                .preferredColorScheme(.light)
            
            // SettingsView Dark
            
            NavigationStack {
                SettingsView(
                    store: Store(
                        initialState: PhotoListReducer.State(themeMode: .dark),
                        reducer: {
                            PhotoListReducer()
                        }
                    ) {
                        $0.userDefaultsClient = .mock
                    }
                )
            }.previewDisplayName(" Settings (Dark)")
                .preferredColorScheme(.dark)
        }//: GROUP
    }
}
