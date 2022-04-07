//
//  File.swift
//  
//
//  Created by Ryan D on 4/6/22.
//

import Foundation
import SwiftUI


struct TitleSlide: View {
    @Binding var slide: Int
    
    @State var bubbles: [Bubble] = []
    
    @State var expandOverlay = false
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Color.white
                    Spacer()
                }
                Spacer()
            }
            Group {
                if self.bubbles.count > 0 {
                ForEach(self.bubbles, id:\.self) {bub in
                    Circle()
                        .fill(
                            LinearGradient(colors: [bub.color1, bub.color2], startPoint: .top, endPoint: .bottomTrailing)
                        )
                        .frame(width: bub.x, height: bub.y)
                        .offset(x:bub.offsetX, y:bub.offsetY)
                        .transition(.scale)
                }
                }
            }
            
            VStack {
                Text("Gradient Descent")
                    .font(.largeTitle)
                    .padding()
                Text("Click anywhere to descend into the gradient")
                    .font(.callout)
                
            }
        }
        .overlay(
            Circle()
                .fill(
                    LinearGradient(colors: [Color("bg3"),Color("bg4")], startPoint: .top, endPoint: .bottomTrailing)
                )
                .frame(width: self.expandOverlay ? 1500 : 0, height: self.expandOverlay ? 1500 : 0)
                .transition(.scale)
                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 1), value: self.expandOverlay)
        )
        .onTapGesture {
            withAnimation(.spring()) {
                for _ in 0...200 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.2...2)) {
                        addBubble()
                    }
                }
            }
//            expand a big gradient and then cool off into white and next slide!

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.expandOverlay = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                self.bubbles = []
                self.slide += 1
            }
        
        }
        .onAppear {
            
        }
    }
    func randomRainbowColor() -> Color {
        let colors: [Color] = [Color("bg2"),Color("bg3"),Color("bg4")]
        return colors.randomElement()!
    }
    func randomOffset() -> Double {
        return Double.random(in: -800...800)
    }
    func addBubble() {
        withAnimation(.spring(
                    response: 0.7,
                    dampingFraction: 0.5,
                    blendDuration: 0.9
                )) {
                    self.bubbles.append(Bubble(offsetX: randomOffset(), offsetY: randomOffset(), color1: randomRainbowColor(), color2: randomRainbowColor(),x:60*Double.random(in: 2...4),y:60*Double.random(in: 2...4)))
        }
    }
}

struct Bubble: Identifiable, Hashable {
    var id = UUID()
    var offsetX: Double
    var offsetY: Double
    var color1: Color
    var color2: Color
    var x: Double
    var y: Double
}

















struct WhatIsGradientDescentSlide: View {
    @Binding var slide: Int
    var body: some View {
        VStack {
            
        }
    }
}


struct Basic2DGradientDescentSlide: View {
    @Binding var slide: Int
    var body: some View {
        VStack {
            
        }
    }
}


struct MoreComplex2DGDSlide: View {
    @Binding var slide: Int
    var body: some View {
        VStack {
            
        }
    }
}

struct Simple3DGDSlide: View {
    @Binding var slide: Int
    var body: some View {
        VStack {
            
        }
    }
}

struct Complex3DGDSlide: View {
    @Binding var slide: Int
    var body: some View {
        VStack {
            
        }
    }
}

struct NextSteps: View {
    @Binding var slide: Int
    var body: some View {
        VStack {
            
        }
    }
}
