//
//  MovieApp.swift
//  Movie
//
//  Created by Robert D'Almeida on 23/11/2022.
//

import SwiftUI

final class AppConfiguration: ObservableObject {
    var storeService = TMDbStoreService()
}

@main
struct MovieApp: App {
    @StateObject var appConfiguration = AppConfiguration()
    var body: some Scene {
        WindowGroup {
            StartingView()
                .environmentObject(appConfiguration)
        }
    }
}

#if DEBUG
extension View {
    func configure() -> some View {
        self.environmentObject(AppConfiguration())
    }
}
#endif
