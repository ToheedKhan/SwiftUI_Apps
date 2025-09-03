//
//  PhotoListReducer.swift
//  PhotoGallery
//
//  Created by Toheed on 31/08/25.
//

import SwiftUI
import ComposableArchitecture


struct PhotoListReducer: Reducer {
    
    typealias State = PhotoListState
    typealias Action = PhotoListAction
    
    // MARK: - A dedicated enum for theme mode
    // This is shared type used by State and Actions.
    enum ThemeMode: String, Equatable, CaseIterable {
        case automatic, dark, light
        
        var colorScheme: ColorScheme? {
            switch self {
            case .automatic: return nil
            case .dark: return .dark
            case .light: return .light
            }
        }
    }
    
    // MARK: State
    // Defines the data for our feature.
    struct PhotoListState: Equatable {
        var photos: [Photo] = []
        var isLoading = false
        var errorMessage: String?
        var themeMode: ThemeMode = .automatic
        var selectedPhoto: Photo?
    }
    
    // MARK: Action
    
    // Defines all possible events that can happen in the feature.
    /*
     The enum PhotoListAction defines every single event that can possibly happen in this feature of the app. This includes:
     
     User interactions, like tapping on a photo to see details or changing the theme in the settings.
     
     System events, like when the view first appears (onAppear) or when a network request is completed (fetchPhotosResponse).
     */
    enum PhotoListAction: Equatable {
        // Sent when the view appears to start the network call.
        case onAppear
        // Sent with the result of the network call.
        case fetchPhotosResponse(TaskResult<[Photo]>)
        
        //Action to handle setting the theme.
        case setTheme(ThemeMode)
        
        // Action to handle showing a photo's details.
        case showPhotoDetails(photo: Photo)
        
        case dismissPhotoDetails
    }
    
    // MARK: Dependencies
    struct PhotosClient {
        var fetchPhotos: @Sendable () async throws -> [Photo]
        
        static let live = PhotosClient(
            fetchPhotos: {
                let url = URL(string: "https://api.slingacademy.com/v1/sample-data/photos?offset=0&limit=20")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(PhotosData.self, from: data)
                return decoded.photos
            }
        )
        
        static let test = PhotosClient(fetchPhotos: { [] })
    }
    
    struct UserDefaultsClient {
        var set: @Sendable (String, String) -> Void
        var get: @Sendable (String) -> String?
        
        static let live = UserDefaultsClient(
            set: { key, value in UserDefaults.standard.set(value, forKey: key) },
            get: { key in UserDefaults.standard.string(forKey: key) }
        )
        
        static let test = UserDefaultsClient(
            set: { _, _ in },
            get: { _ in "automatic" }
        )
    }
    
    // MARK: Properties
    let photosClient: PhotosClient
    let userDefaultsClient: UserDefaultsClient
    
    private static let themeKey = "themeMode"
    
    // MARK: Reducer
    func reduce(into state: inout PhotoListState, action: PhotoListAction) -> Effect<PhotoListAction> {
        switch action {
        case .onAppear:
            if let savedThemeString = userDefaultsClient.get(Self.themeKey),
               let savedTheme = ThemeMode(rawValue: savedThemeString) {
                state.themeMode = savedTheme
            }
            
            state.isLoading = true
            state.errorMessage = nil
            
            return .run { send in
                await send(.fetchPhotosResponse(TaskResult { try await photosClient.fetchPhotos() }))
            }
            
        case let .fetchPhotosResponse(.success(photos)):
            state.photos = photos
            state.isLoading = false
            return .none
            
        case let .fetchPhotosResponse(.failure(error)):
            state.errorMessage = "Failed to load photos: \(error.localizedDescription)"
            state.isLoading = false
            return .none
            
        case let .setTheme(theme):
            state.themeMode = theme
            return .run { _ in
                self.userDefaultsClient.set(Self.themeKey, theme.rawValue)
            }
            
            
        case .showPhotoDetails(let photo):
            state.selectedPhoto = photo
            return .none
            
        case .dismissPhotoDetails:
            state.selectedPhoto = nil     //  clear selection
            return .none
        }
        
    }
}
