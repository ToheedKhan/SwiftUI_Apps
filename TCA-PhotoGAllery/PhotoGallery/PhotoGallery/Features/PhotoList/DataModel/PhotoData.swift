//
//  PhotoData.swift
//  PhotoGallery
//
//  Created by Toheed on 01/09/25.
//

import Foundation

// MARK: - Data Models
struct Photo: Identifiable, Decodable, Equatable {
    let id: Int
    let url: String
    let title: String
    let description: String
}

struct PhotosData: Decodable, Equatable {
    let photos: [Photo]
}
