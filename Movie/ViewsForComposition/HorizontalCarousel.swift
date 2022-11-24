//
//  HorizontalCarousel.swift
//  Movie
//
//  Created by Robert D'Almeida on 24/11/2022.
//

import SwiftUI

extension HorizontalCarousel {
    struct Item: Identifiable {
        var order: Int
        var title: String
        var color: Color
        
        var id: Int {
            order
        }
    }

    class Store: ObservableObject {
        @Published var items: [Item]
        
        let colors: [Color] = [.red, .orange, .blue, .teal, .mint, .green, .gray, .indigo, .black]

        // dummy data
        init() {
            items = []
            for i in 0...7 {
                let new = Item(order: i, title: "Item \(i)", color: colors[i])
                items.append(new)
            }
        }
    }
}

struct HorizontalCarousel: View {
    @StateObject var store = Store()
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    
    var body: some View {
        
        ZStack {
            ForEach(store.items) { item in
                
                // article view
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(item.color)
                    Text(item.title)
                        .padding()
                }
                .frame(width: 200, height: 200)
                
                .scaleEffect(1.0 - abs(distance(item.order)) * 0.2 )
//                .opacity(1.0 - abs(distance(item.order)) * 0.3 )
                .offset(x: myXOffset(item.order), y: 0)
                .zIndex(1.0 - abs(distance(item.order)) * 0.1)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    draggingItem = snappedItem + value.translation.width / 100
                }
                .onEnded { value in
                    withAnimation {
                        draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                        draggingItem = round(draggingItem).remainder(dividingBy: Double(store.items.count))
                        snappedItem = draggingItem
                    }
                }
        )
    }
    
    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item)).remainder(dividingBy: Double(store.items.count))
    }
    
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(store.items.count) * distance(item)
        return sin(angle) * 200
    }
    
}

struct HorizontalCarousel_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalCarousel()
    }
}
