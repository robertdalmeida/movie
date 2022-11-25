//
//  MovieDetailView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct MovieDetailView: View {
    let media: Media
    @State var offline = false
    var body: some View {
        VStack{
            if offline {
                OfflineIndicator()
                    .transition(.slide)
                    .padding()
            }
            AsyncImage(url: media.image) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }.padding([.bottom])
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
