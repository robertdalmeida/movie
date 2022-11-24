//
//  DiscoverView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        VStack {
            Spacer()
            MostPopularView()
            Spacer()
            NowPlayingView()
            Spacer()
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .configure()
    }
}
