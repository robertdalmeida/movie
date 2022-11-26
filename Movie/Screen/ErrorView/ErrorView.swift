//
//  ErrorView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        Spacer()
        Text("⚠️")
            .font(.title)
        Spacer()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
            .configure()
    }
}
