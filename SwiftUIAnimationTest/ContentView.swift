//
//  ContentView.swift
//  SwiftUIAnimationTest
//
//  Created by Ekaterina Kolesnikova on 5/24/23.
//

import SwiftUI


struct ContentView: View {
    @State private var offset: CGFloat = 0
    
    let colors = Array(0..<10).map({ _ in Color.random })
    let threshold: CGFloat = 100
    let viewHeight: CGFloat = 727 // TODO: get real value
    let safeAreaTop: CGFloat = 75 // TODO: get real value
    
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(Array(colors.enumerated()), id: \.offset) { (_, color) in
                    Rectangle()
                        .fill(color)
                        .frame(height: 200)
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")))
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    let scrollViewOffset = (value.size.height - (75 - value.origin.y)) - viewHeight
                    guard scrollViewOffset < threshold else {
                        self.offset = 0
                        return
                    }
                    self.offset = scrollViewOffset - threshold
                }
            }
            
            VStack {
                Spacer()
                
                Button {
                    print("Button clicked")
                } label: {
                    Text("Button")
                        .foregroundColor(Color.black)
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .padding(20)
                .offset(y: offset)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    }
}
