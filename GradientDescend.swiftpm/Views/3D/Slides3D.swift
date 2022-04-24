//
//  Slides3D.swift
//  
//
//  Created by Ryan D on 4/17/22.
//

import Foundation
import SwiftUI


struct Simple3DGDSlide: View {
    @Binding var slide: Int
    let textFont = Font
        .system(size: 20)
        .monospaced()
    let boldedTextFont = Font
        .system(size: 20)
        .bold()
        .monospaced()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var time = 0
    @State var cardIndex = 0
    @State var hideOverlayLine = false
    
    @State var geo: GeometryProxy? = nil
    
    @State var xValue = 0.0
    
    @State var counter = 0
    
    @State var dropBall = false
    
    
    var body: some View {
        
        ZStack {
            Color.black
            VStack {
                HStack {
                    // explanation
                    VStack(alignment: .leading) {
                        Text("3D Gradient Descent")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .padding(.bottom)
                            .foregroundColor(.white)
                        ScrollView {
                            ScrollViewReader { value in
                                VStack(alignment: .leading) {
                                    
                                    
                                    // at the same time card index 1, show the graph
                                    Group {
                                        Text("Now let's take a look at an example of a neural network with ").font(textFont).foregroundColor(.white) + Text("two parameters").font(boldedTextFont).foregroundColor(.white) + Text(". This takes us to the third dimension!").font(textFont).foregroundColor(.white)
                                    }.padding()
                                        .opacity(cardIndex > 0 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(0)
                                    
                                    Group {
                                        Text("To simulate gradient descent, let's drop a ball and let it minimize the error of this model. Pan around to get a good view of the model, then click drop.").font(textFont).foregroundColor(.white)
                                        
                                        Button(action: {
                                            self.dropBall.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                self.cardIndex += 1
                                            }
                                        }, label: {
                                            Text("Drop Ball")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(
                                                    RoundedRectangle(cornerRadius: 24)
                                                        .fill(Color("bg4"))
                                                )
                                        })
                                    }.padding()
                                        .opacity(cardIndex > 1 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(1)
                                    
                                    
                                    
                                    Group {
                                        Text("Congratulations!").font(boldedTextFont).foregroundColor(Color("bg4")) + Text("""
                                        You've completed this playground app! Thank you for your time and I hope you have a great WWDC2022!
                                        
                                        If you'd like, you can go back to the previous modules with the button on the bottom right.
                                        """).font(textFont).foregroundColor(.white)
                                    }.padding()
                                        .opacity(cardIndex > 2 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(2)
                                    
                                    Spacer()
                                    
                                    
                                }
                                
                                .onChange(of: self.cardIndex) { _ in
                                    if self.cardIndex == 3 {
                                        self.counter += 1
                                    }
                                    withAnimation(.easeInOut) {
                                        value.scrollTo(self.cardIndex - 1, anchor: .top)
                                    }
                                }
                                
                            }
                        }
                        
                        if self.cardIndex < 3 && self.cardIndex != 2 {
                            Button(action: {
                                if self.cardIndex < 7 {
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
                        }
                    }
                    
                    // interactive stuff !!!
                    HStack {
                        
                        Simple3DView(dropBall: $dropBall)
                            .id("grid")
                    }
                }
                .padding(.top)
                .padding()
            }
            ConfettiCannon(counter: self.$counter, num: 100, radius: 450)
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
        
    }
}

