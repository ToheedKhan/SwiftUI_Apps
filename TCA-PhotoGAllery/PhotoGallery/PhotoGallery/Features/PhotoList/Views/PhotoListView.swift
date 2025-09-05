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
                                
                                NavigationLink(value: photo) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: 8) {
                                            if photo.url.hasPrefix("local:") {
                                                let assetName = photo.url.replacingOccurrences(of: "local:", with: "")
                                                    Image(
                                                    assetName
                                                )
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .cornerRadius(8)
                                            } else {
                                                AsyncImage(url: URL(string: photo.url)) { image in
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .cornerRadius(8)
                                                } placeholder: {
                                                    ProgressView()
                                                        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200, alignment: .center)
//                                                        .frame(maxWidth: .infinity, alignment: .center)
                                                        .padding()
                                                        .background(Color.gray.opacity(0.1))
                                                        .cornerRadius(8)
                                                }
                                            }
                                            Text(photo.title)
                                                .font(.headline)
                                            Text(photo.description)
                                                .font(.subheadline)
                                        }
                                        .padding(.vertical, 8)
                                }//: NAVIGATION LINK
                            }
                        } //: LIST
                        .navigationDestination(for: Photo.self) { photo in
                            PhotoDetailView(photo: photo)
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
        Group {
            // MARK: Preview using testValue
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
                    reducer: { PhotoListReducer() }
                ) {
                    // built-in TCA test values
                    $0.photosClient = .testValue
                    $0.userDefaultsClient = .testValue
                }
            )
            .previewDisplayName("Photo List (testValue)")
            
            // MARK: Preview using mock
            PhotoListView(
                store: Store(
                    initialState: PhotoListReducer.State(),
                    reducer: { PhotoListReducer() }
                ) {
                    // custom mocks from Mocks.swift
                    $0.photosClient = .mock
                    $0.userDefaultsClient = .mock
                }
            )
            .previewDisplayName("Photo List (mock)")
        }
    }
}




/*
 Key Difference
 
 .testValue: Provided automatically when your dependency conforms to TestDependencyKey. Usually returns empty/fake values.
 
 .mock: You define yourself (in Mocks.swift), so you can fill with realistic sample data for previews.
 
 Best practice:
 
 Use .mock in previews (so you see data).
 
 Use .testValue in unit tests (deterministic, no assumptions).
 */
