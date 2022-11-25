//
//  FavoritesView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var mediaNavigationCoordinator: MediaNavigationCoordinator

    var body: some View {
        Text("Favorites")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .configure()
    }
}
