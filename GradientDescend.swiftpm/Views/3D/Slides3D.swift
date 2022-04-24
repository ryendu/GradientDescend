//
//  File.swift
//  
//
//  Created by Ryan D on 4/17/22.
//

import Foundation
import SwiftUI
//import IrregularGradient
//import ConfettiSwiftUI



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
    
    
    var body: some View {
        
        ZStack {
            Color.black
            VStack {
                HStack {
                    // explanation
                    VStack(alignment: .leading) {
                        Text("Gradient Descent on Another Dimension")
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
                                        Text("Realistically, neural networks would have ").font(textFont).foregroundColor(.white) + Text("Millions to Billions").font(boldedTextFont).foregroundColor(.white) + Text(" of parameters, as each parameter adds another dimension. We can't percieve anything more than 3 dimensions, but to show how more complex gradient descent algorithms work, lets go to the third dimension.").font(textFont).foregroundColor(.white)
                                    }.padding()
                                        .opacity(cardIndex > 0 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(0)
                                    
                                    Group {
                                        Text("Yo wasn't that cool? Try panning around the 3d model!").font(textFont).foregroundColor(.white)
                                    }.padding()
                                        .opacity(cardIndex > 1 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(2)
                                    
                                    //id 3 goes to the about page which acts as conslusion!
                                    
                                    
                                    Spacer()
                                    
                                    
                                }
                                
                                .onChange(of: self.cardIndex) { _ in
                                    withAnimation(.easeInOut) {
                                        value.scrollTo(self.cardIndex, anchor: .center)
                                    }
                                }
                                
                            }
                        }
                        
                        if self.cardIndex != 3 {
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
                    
                    // intearctive stuff !!!
                    HStack {
                        
                        Simple3DView(cardIndex: $cardIndex)
                            .id("grid")
//                            .opacity(self.hideOverlayLine ? 1 : 0)
//                            .animation(.default, value: self.hideOverlayLine)
                    }//.frame(width: (geo?.size.width ?? 100) * 0.4)
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

