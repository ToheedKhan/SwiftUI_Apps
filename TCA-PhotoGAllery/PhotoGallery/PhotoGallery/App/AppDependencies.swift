//
//  AppDependencies.swift
//  PhotoGallery
//
//  Created by Toheed on 03/09/25.
//

import ComposableArchitecture

extension PhotoListReducer.PhotosClient: DependencyKey, TestDependencyKey {
    static var liveValue: PhotoListReducer.PhotosClient {
        .live
    }
    
    static var testValue: PhotoListReducer.PhotosClient {
        .test
    }
}

extension PhotoListReducer.UserDefaultsClient: DependencyKey, TestDependencyKey {
    static var liveValue: PhotoListReducer.UserDefaultsClient {
        .live
    }
    
    static var testValue: PhotoListReducer.UserDefaultsClient {
        .test
    }
}


