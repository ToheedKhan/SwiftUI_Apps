//
//  PhotoListView.swift
//  PhotoGallery
//
//  Created by Toheed on 31/08/25.
//

import SwiftUI
import ComposableArchitecture

// This is the SwiftUI view that observes the store and renders the UI.

struct PhotoListView: View {
    let store: StoreOf<PhotoListReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            NavigationStack {
                VStack {
                    if viewStore.isLoading {
                        ProgressView("Loading Photos...").controlSize(.large)
                    } else if let errorMessage = viewStore.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .padding()
                    } else {
                        List {
                            ForEach(viewStore.photos) {
                                photo in
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 8) {
                                        AsyncImage(url: URL(string: photo.url)) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(height: 200)
                                        }
                                        Text(photo.title)
                                            .font(.headline)
                                        Text(photo.description)
                                            .font(.subheadline)
                                    }
                                    .padding(.vertical, 8)
                            }
                        }
                    }//: ELSE
                }//: VSTACK
                .navigationTitle("Photo Gallery")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView(store: store)) {
                            Image(systemName: "gearshape.fill")
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }//: NAVIGATION STACK
            .preferredColorScheme(viewStore.themeMode.colorScheme)
        }
    }//:BODY
}

//#Preview {
//    //    PhotoListView()
//}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView(
            store: Store(
                initialState: PhotoListReducer.State(
                    photos: [
                        Photo(id: 1, url: "", title: "Sample 1", description: "Desc 1"),
                        Photo(id: 2, url: "", title: "Sample 2", description: "Desc 2")
                    ],
                    isLoading: false,
                    themeMode: .automatic
                ),
                reducer: {
                    PhotoListReducer(
                        photosClient: .test,
                        userDefaultsClient: .test
                    )
                }
            )
        )
        .previewDisplayName("Photo List Preview")
    }
}
