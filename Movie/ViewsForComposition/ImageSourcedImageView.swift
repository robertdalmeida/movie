//
//  ImageSourcedImageView.swift
//  Movie
//
//  Created by Robert D'Almeida on 28/11/2022.
//

import SwiftUI

struct SourcedImageView: View {
    let imageSource: ImageSource
    @EnvironmentObject var imageStoreService: ImageStore
    var contentMode: ContentMode
    
    init(imageSource: ImageSource, contentMode: ContentMode = .fit) {
        self.imageSource = imageSource
        self.contentMode = contentMode
    }

    @ViewBuilder
    var body: some View {
        switch imageSource {
        case .noPoster:
            Image("no-photo-available")
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: contentMode)
                .clipShape(RoundedRectangle(cornerRadius: 15.0))

        case .url(let url):
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: contentMode)
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
            } placeholder: {
                ProgressView()
            }
        case .localFile(let fileIdentifier):
            if let image = imageStoreService.retrieveImage(id: fileIdentifier) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: contentMode)
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))

            } else {
                ErrorView(message: "")
            }
        }
    }
}

#if DEBUG
struct SourcedImageView_Previews: PreviewProvider {
    static var previews: some View {
        SourcedImageView(imageSource: .noPoster)
    }
}
#endif
