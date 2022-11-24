//
//  MostPopularView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct MostPopularView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Most Popular")
                    .applyAppStyle(.title)
                    .padding()
                Spacer()
            }
            HorizontalCarousel()
        }
    }
}

struct MostPopularView_Previews: PreviewProvider {
    static var previews: some View {
        MostPopularView()
    }
}
