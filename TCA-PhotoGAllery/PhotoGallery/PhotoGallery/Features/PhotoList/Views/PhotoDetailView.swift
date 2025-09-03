//
//  PhotoDetailView.swift
//  PhotoGallery
//
//  Created by Toheed on 03/09/25.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: photo.url)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView().frame(height: 300)
                }

                Text(photo.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                //system dynamic colors or gradients/materials
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Text(photo.description)
                    .font(.body)
                //static color
                    .foregroundColor(.secondary)
                
            } //: VSTACK
            .padding()
        }//: ScrollView
        .navigationTitle("Photo Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PhotoDetailView(photo: Photo(id: 1, url: "", title: "Test", description: "This is good."))
}
