//
//  ErrorView.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    var body: some View {
        Spacer()
        Text("⚠️")
            .applyAppStyle(.errorText)
        Text(message)
            .applyAppStyle(.errorText)
        Spacer()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Something failed")
            .configure()
    }
}
