//
//  SettingsView.swift
//  PhotoGallery
//
//  Created by Toheed on 01/09/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<PhotoListReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section(header: Text("App Theme")) {
                    Picker(
                        "Appearance",
                        selection: viewStore
                            .binding(
                                get: \.themeMode,
                                send: PhotoListReducer.Action.setTheme
                            )) {
                                ForEach(PhotoListReducer.ThemeMode.allCases, id:\.self) {
                                    theme in
                                    Text(theme.rawValue.capitalized)
                                        .tag(theme)
                                }
                            }
                            .pickerStyle(.segmented)
                }
            } //: FORM
            .navigationTitle("Settings")
            
        }

    }
}


//#Preview {
//    SettingsView()
//}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            store: Store(
                initialState: PhotoListReducer.PhotoListState(themeMode: .light), // mock state
                reducer: {
                    PhotoListReducer(
                        photosClient: .test,
                        userDefaultsClient: .test
                    )
                }
            )
        )
        .previewDisplayName("Light Mode")
        
        SettingsView(
            store: Store(
                initialState: PhotoListReducer.PhotoListState(themeMode: .dark), // mock state
                reducer: {
                    PhotoListReducer(
                        photosClient: .test,
                        userDefaultsClient: .test
                    )
                }
            )
        )
        .previewDisplayName("Dark Mode")
    }
}

