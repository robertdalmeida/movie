//
//  MovieDetailView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct MovieDetailView: View {
    let media: Media
    var body: some View {
        VStack{
            AsyncImage(url: media.image) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            HStack {
                VStack {
                    Text(media.title)
                        .applyAppStyle(.title)
                    if let releaseDate = media.releaseDate {
                        Text(releaseDate, style: .date)
                    }
                }
                Spacer()
                Button("Favorite") {
                    print("Save a Favorite")
                }
            }
            .padding()
        }.navigationTitle(media.title)
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(media: .mock)
            .configure()
    }
}
