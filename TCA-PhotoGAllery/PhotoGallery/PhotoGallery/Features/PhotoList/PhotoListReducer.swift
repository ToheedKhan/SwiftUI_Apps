//
//  PhotoListReducer.swift
//  PhotoGallery
//
//  Created by Toheed on 31/08/25.
//

import SwiftUI
import ComposableArchitecture


struct PhotoListReducer: Reducer {
    
//    typealias State = PhotoListState
//    typealias Action = PhotoListAction
    
    
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
    
    /*
     In TCA 1.x, your State must conform to ObservableState so that SwiftUI views (via WithViewStore) can observe it properly.
     
     Newer TCA versions (1.10+), ObservableState expects a special @ObservableState macro annotation
     */
//    struct PhotoListState: Equatable, ObservableState {
    
    @ObservableState
    struct State: Equatable {
        var photos: [Photo] = []
        var isLoading = false
        var errorMessage: String?
        var themeMode: ThemeMode = .automatic
//        var selectedPhoto: Photo?
    }
    
    // MARK: Action
    
    // Defines all possible events that can happen in the feature.
    /*
     The enum PhotoListAction defines every single event that can possibly happen in this feature of the app. This includes:
     
     User interactions, like tapping on a photo to see details or changing the theme in the settings.
     
     System events, like when the view first appears (onAppear) or when a network request is completed (fetchPhotosResponse).
     */
    enum Action: Equatable {
        // Sent when the view appears to start the network call.
        case onAppear
        // Sent with the result of the network call.
        case fetchPhotosResponse(TaskResult<[Photo]>)
        
        //Action to handle setting the theme.
        case setTheme(ThemeMode)
        
        // Action to handle showing a photo's details.
//        case showPhotoDetails(photo: Photo)
//        
//        case dismissPhotoDetails
        
        /*
         modern NavigationStack with NavigationLink(value:) + .navigationDestination(for:), we no longer need to manually track selectedPhoto in state or reducer. SwiftUI handles navigation state by value.
         */
    }
    
    // MARK: Dependencies
    @Dependency(PhotosClient.self) var photosClient
    @Dependency(UserDefaultsClient.self) var userDefaultsClient
    
    private static let themeKey = "themeMode"
    
    // MARK: Reducer
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
                userDefaultsClient.set(Self.themeKey, theme.rawValue)
            }
            
            
//        case .showPhotoDetails(let photo):
//            state.selectedPhoto = photo
//            return .none
//            
//        case .dismissPhotoDetails:
//            state.selectedPhoto = nil     //  clear selection
//            return .none
        }
        
    }
}
