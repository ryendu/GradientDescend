//
//  File.swift
//  
//
//  Created by Ryan D on 4/6/22.
//

import Foundation
import SwiftUI
import IrregularGradient

struct CircleToLine: Shape {
    
    var becomeLine: Bool
    
    var animatableData: Bool {
        get { becomeLine }
        set { becomeLine = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect)
        
        if self.becomeLine {
            path.addRect(rect)
        }
        
        return path
    }
}


struct TitleSlide: View {
    @Binding var slide: Int
    @Binding var geo: GeometryProxy?
    
    @State var bubbles: [Bubble] = []
    
    @State var expandOverlay = false
    @State var reshrinkOverlay = false
    @State var hideContent = false
    
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
            if self.hideContent {
                Color.white
            }
        }
        .overlay(
            CircleToLine(becomeLine: self.reshrinkOverlay)
                
                .fill(
                    LinearGradient(colors: [Color("bg3"),Color("bg4")], startPoint: .top, endPoint: .bottomTrailing)
                )
            
                .frame(width: self.expandOverlay || self.reshrinkOverlay ? 1500 : 0, height: self.expandOverlay ? 1500 : ( self.reshrinkOverlay ? 10 : 0))
                .transition(.scale)
                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 1), value: self.expandOverlay)
                .offset(x: 0, y: self.reshrinkOverlay ? (geo?.size.height ?? 100) / -2 + 100  : 0)
                
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.bubbles = []
                self.hideContent = true
                self.reshrinkOverlay = true
                self.expandOverlay = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
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
    var geoSize: CGSize?
    
    let textFont = Font
        .system(size: 24)
        .monospaced()
    let boldedTextFont = Font
        .system(size: 24)
        .bold()
        .monospaced()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var time = 0
    @State var cardIndex = 0
    
    @State var hillGeo: GeometryProxy? = nil
    
    let times = [0,2,2,2,2]
    var body: some View {
        VStack {
            HStack {
                // explanation
                VStack(alignment: .leading) {
                    Text("What Is Gradient Descent?")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .padding(.bottom)
                    
                    Group {
                        Text("Gradient Descent").font(boldedTextFont) + Text(" is the algorithm used to train Machine Learning Models and Neural Networks.")
                            .font(textFont)
                    }.padding()
                        .opacity(cardIndex > 0 ? 1 : 0)
                        .animation(.spring(), value: self.cardIndex)
                    
                    Group {
                        Text("Neural networks ").font(boldedTextFont) + Text("are made up of ").font(textFont) + Text("Weights and Biases").font(boldedTextFont) + Text(" and the output of a Neural Net can be tweaked by adjusting these Weights and Biases.").font(textFont)
                    }.padding()
                        .opacity(cardIndex > 1 ? 1 : 0)
                        .animation(.spring(), value: self.cardIndex)
                    
                    Group {
                        Text("Gradient Descent").font(boldedTextFont) + Text(" uses training data to iteratively adjust the ").font(textFont) + Text("Weights and Biases").font(boldedTextFont) + Text(" of the Model to achieve the smallest possible error (minimizing the cost function).  ").font(textFont)
                        
                        
                            
                    }.padding()
                        .opacity(cardIndex > 2 ? 1 : 0)
                        .animation(.spring(), value: self.cardIndex)
                    
                    Button(action: {
                        if self.cardIndex < self.times.count - 1 {
                            self.cardIndex += 1
                        } else {
                            self.slide += 1
                        }
                    }, label: {
                        Text("Next")
                            .font(boldedTextFont)
                            .padding()
                            .padding(.top)
                            .irregularGradient(colors: [Color("bg5"),Color("bg3"),Color("bg4")], backgroundColor: Color("bg4"))
                            .scaleEffect(self.time % 2 == 0 ? 1 : 1.1)
                            .animation(.easeInOut(duration: 1), value: self.time)
                    })
                    
                    Spacer()
                }
                
                Spacer()
                // rolling ball down a hill
                HStack {
                    NeuralNetwork()
                }.frame(minWidth:100)
            }
            .padding(.top)
            .padding()
        }
        
        .onAppear {
        }
        .onReceive(timer) { date in
            self.time += 1
            if self.time > self.times[self.cardIndex] && self.cardIndex == 0 {
                self.time = 0
                if cardIndex < self.times.count - 1 {
                    self.cardIndex += 1
                }
            }
        }
        
        .overlay(
            CircleToLine(becomeLine: true)
                
                .fill(
                    LinearGradient(colors: [Color("bg3"),Color("bg4")], startPoint: .top, endPoint: .bottomTrailing)
                )
            
                .frame(width:1500, height:10)
                .transition(.scale)
                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 1))
                .offset(x: 0, y: (geoSize?.height ?? 100) / -2 + 100)
                
        )
    }
}

struct NeuralNetwork: View {
    var body: some View {
        VStack{
            //TODO: IF HAS TIME
        }
    }
}

struct Basic2DGradientDescentSlide: View {
    @Binding var slide: Int
    let textFont = Font
        .system(size: 22)
        .monospaced()
    let boldedTextFont = Font
        .system(size: 22)
        .bold()
        .monospaced()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var time = 0
    @State var cardIndex = 0
    @State var hideOverlayLine = false
    
    @State var geo: GeometryProxy? = nil
    
    let times = [1,2,2,2,2]
    var body: some View {
        VStack {
            HStack {
                // explanation
                VStack(alignment: .leading) {
                    Text("How does Gradient Descent Work?")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .padding(.bottom)
                    
                    // at the same time card index 1, show the graph
                    Group {
                        Text("Say we have a model with just ").font(textFont) + Text("one adjustable parameter. ").font(boldedTextFont) + Text("The graph on the right is the graph of its ").font(textFont) + Text("cost function").font(boldedTextFont) + Text(", where the ").font(textFont) + Text("X").font(boldedTextFont) + Text(" axis represents the value of that one adjustable parameter and the ").font(textFont) + Text("Y").font(boldedTextFont) + Text(" axis represents the corresponding error produced by the model with parameter ").font(textFont) + Text("X").font(boldedTextFont) + Text(".").font(textFont)
                    }.padding()
                        .opacity(cardIndex > 0 ? 1 : 0)
                        .animation(.spring(), value: self.cardIndex)
                    
                    //when its card index 2, wait 2 seconds and have the animation of the steps
                    Group {
                        Text("The model is initialized with an ").font(textFont) + Text("arbitrary starting point").font(boldedTextFont) + Text(" and from there, gradient descent calculates the ").font(textFont) + Text("derivative").font(boldedTextFont) + Text(" (or slope) of the point and adjust the Weights and Biases of the model to take a step in the direction with the steepest downward slope. ").font(textFont)
                    }.padding()
                        .opacity(cardIndex > 1 ? 1 : 0)
                        .animation(.spring(), value: self.cardIndex)
                    
                    
                    
                    Button(action: {
                        if self.cardIndex < self.times.count - 1 {
                            self.cardIndex += 1
                        } else {
                            self.slide += 1
                        }
                    }, label: {
                        Text("Next")
                            .font(boldedTextFont)
                            .padding()
                            .padding(.bottom)
                            .padding(.bottom)
                            .irregularGradient(colors: [Color("bg5"),Color("bg3"),Color("bg4")], backgroundColor: Color("bg4"))
                            .scaleEffect(self.time % 2 == 0 ? 1 : 1.1)
                            .animation(.easeInOut(duration: 1), value: self.time)
                    })
                    
                    Spacer()
                    
                    
                }
                
                
                Spacer()
                // intearctive stuff !!!
                HStack {
                    SimpleInteractiveGraph2DView(cardIndex: $cardIndex)
                        .opacity(self.hideOverlayLine ? 1 : 0)
                        .animation(.default, value: self.hideOverlayLine)
                }//.frame(width: (geo?.size.width ?? 100) * 0.4)
            }
            .padding(.top)
            .padding()
        }
        
        .onAppear {
        }
        .onReceive(timer) { date in
            self.time += 1
            if self.time > 0  {
                self.hideOverlayLine = true
            }
        }
        
        .overlay(
            GeometryReader { geo in
                Text("")
                    .onAppear {
                        self.geo = geo
                    }
            }
            
        )
        
        .overlay(
            CircleToLine(becomeLine: true)
                
                .fill(
                    LinearGradient(colors: [Color("bg3"),Color("bg4")], startPoint: .top, endPoint: .bottomTrailing)
                )
            
                .frame(width:1500, height:10)
                .transition(.scale)
                .animation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 1))
                .offset(x: 0, y: (geo?.size.height ?? 100) / -2 + 160)
                .opacity(self.hideOverlayLine ? 0 : 1)
                .animation(.default, value: self.hideOverlayLine)
                
        )
        
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
