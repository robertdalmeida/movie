import SwiftUI

struct OfflineIndicator: View {
    var body: some View {
        ZStack {
            Color(.lightGray)
                .opacity(0.7)
            HStack {
                Text("You are currently offline")
            }
        }
        .frame(height: 30)
    }
}

#if DEBUG
struct OfflineIndicator_Previews: PreviewProvider {
    static var previews: some View {
        OfflineIndicator()
    }
}
#endif
