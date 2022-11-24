//
//  NowPlayingView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct NowPlayingView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Now Playing")
                    .applyAppStyle(.title)
                    .padding()
                Spacer()
            }
            HorizontalCarousel()
        }
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView()
    }
}
