import SwiftUI

/// An error screen that can be displayed anywhere in the app.
struct ErrorView: View {
    let message: String
    var body: some View {
        Text("⚠️")
            .applyAppStyle(.errorText)
        Text(message)
            .applyAppStyle(.errorText)
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Something failed")
    }
}
#endif
