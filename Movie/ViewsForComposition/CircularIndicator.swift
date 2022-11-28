import SwiftUI

struct CircularIndicator: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                HStack {
                    Text("\(Int(progress * 100))")
                        .font(.system(size: g.size.width * 0.35))
                        .bold()
                        .foregroundColor(.black)
                        .offset(x: 4)

                    VStack {
                        Text("%")
                            .font(.system(size: g.size.width * 0.16))
                            .bold()
                            .foregroundColor(.black)
                            .offset(x: -4, y: -2)
                    }
                }

                Circle()
                    .stroke(
                        Color.black.opacity(0.5),
                        lineWidth: g.size.width * 0.25
                    )
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.green,
                        style: StrokeStyle(
                            lineWidth: g.size.width * 0.25,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
            }
        }
    }
}

#if DEBUG
struct CircularIndicator_Previews: PreviewProvider {
    static var previews: some View {
        CircularIndicator(progress: 0.3)
            .frame(width: 60, height: 60)
    }
}
#endif
