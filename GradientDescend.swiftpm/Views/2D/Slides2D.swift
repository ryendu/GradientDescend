//
//  Slides2D.swift
//  
//
//  Created by Ryan D on 4/6/22.
//

import Foundation
import SwiftUI

struct Bubble: Identifiable, Hashable {
    var id = UUID()
    var offsetX: Double
    var offsetY: Double
    var color1: Color
    var color2: Color
    var x: Double
    var y: Double
}


struct Basic2DGradientDescentSlide: View {
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
    
    @Binding var zoomedOut: Bool
    @Binding var selectedView: MainView
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    // explanation
                    VStack(alignment: .leading) {
                        Text("How does Gradient Descent Work?")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .padding(.bottom)
                        ScrollView {
                            ScrollViewReader { value in
                                VStack(alignment: .leading) {
                                    
                                    
                                    // at the same time card index 1, show the graph
                                    Group {
                                        Text("The graph on the right plots a neural network's parameters on the ").font(textFont) + Text("x axis").font(boldedTextFont) + Text(", and the corresponding error given by those parameters on the ").font(textFont) + Text("y axis.").font(boldedTextFont)
                                    }.padding()
                                        .opacity(cardIndex > 0 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(0)
                                    
                                    //when its card index 2, wait 2 seconds and have the animation of the steps
                                    Group {
                                        Text("The model is initialized at an ").font(textFont) + Text("arbitrary point").font(boldedTextFont) + Text(" and the Gradient Descent algorithm adjusts the model to minimize the error as much as possible.").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 1  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(1)
                                    
                                    Group {
                                        Text("You try first! Adjust the slider below to get the model to have the lowest error.").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 2  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(2)
                                    
                                    Slider(value: $xValue, in: 0...10, onEditingChanged: { editing in
                                        if round(xValue) == 5.0 {
                                            self.counter += 1
                                            self.cardIndex += 1
                                        }
                                    }).padding()
                                        .opacity(cardIndex > 2 ? 1 : 0)
                                        .id(3)
                                        .disabled(cardIndex != 3)
                                    
                                    Group {
                                        Text("You got it! ").font(textFont).foregroundColor(.green)
                                    }.padding()
                                        .opacity(cardIndex > 3 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(4)
                                    
                                    
                                    Group {
                                        Text("Gradient descent calculates the ").font(textFont) + Text("derivative").font(boldedTextFont) + Text(" (or slope) of the current point and adjusts the model towards the ").font(textFont) + Text("steepest downward slope").font(boldedTextFont) + Text(" until it reaches the smallest error possible.").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 4 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(5)
                                    
                                    Group {
                                        Text("This is ").font(textFont) + Text("gradient descent").font(boldedTextFont) + Text(" in action! ").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 5 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(6)
                                    
                                    
                                    
                                    Group {
                                        Text("Now you should have a basic understanding of how gradient descent works! Let's move on to the next section.").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 6 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(7)
                                    
                                    Spacer()
                                    
                                }
                                
                                .onChange(of: self.cardIndex) { _ in
                                    withAnimation(.easeInOut) {
                                        value.scrollTo(self.cardIndex - 1, anchor: .top)
                                    }
                                }
                                
                            }
                        }
                        
                        if cardIndex <= 6 && cardIndex != 3 {
                            Button(action: {
                                self.cardIndex += 1
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
                        if self.cardIndex >= 7 {
                            Button(action: {
                                withAnimation(.spring()) {
                                    self.zoomedOut = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    withAnimation(.spring()) {
                                        self.selectedView = .learn2DGDView
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                    withAnimation(.spring()) {
                                        self.zoomedOut = false
                                    }
                                }
                            }, label: {
                                Text("Next")
                                    .font(.system(size: 23)
                                        .bold()
                                        .monospaced())
                                    .padding()
                                    .padding(.bottom)
                                    .padding(.bottom)
                                    .irregularGradient(colors: [Color("bg5"),Color("bg3"),Color("bg4")])
                                    .scaleEffect(self.time % 2 == 0 ? 1 : 1.1)
                                    .animation(.easeInOut(duration: 1), value: self.time)
                            })
                        }
                    }
                    
                    // interactive stuff !!!
                    HStack {
                        SimpleInteractiveGraph2DView(cardIndex: $cardIndex, xValue: $xValue)
                            .opacity(self.hideOverlayLine ? 1 : 0)
                            .animation(.default, value: self.hideOverlayLine)
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


struct MoreComplex2DGDSlide: View {
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
    
    @State var learningRate = 0.01
    
    @State var learningRateIndx = 1.0
    
    @Binding var zoomedOut: Bool
    @Binding var selectedView: MainView
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    // explanation
                    VStack(alignment: .leading) {
                        Text("Learning Rates and Local Minima")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .padding(.bottom)
                        ScrollView {
                            ScrollViewReader { value in
                                VStack(alignment: .leading) {
                                    
                                    // at the same time card index 1, show the graph
                                    Group {
                                        Text("""
                                            Now let's look at a more complex example of gradient descent.
                                            
                                            Here, we have a model with two
                                            """).font(textFont) + Text(" local minima").font(boldedTextFont) + Text(" (canyons), lets run gradient descent and observe what happens. ").font(textFont) + Text(" (click next)").font(boldedTextFont)
                                    }.padding()
                                        .opacity(cardIndex > 0 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(0)
                                    
                                    //when its card index 2, wait 2 seconds and have the animation of the steps
                                    Group {
                                        Text("Did you notice how gradient descent didn't fully reduce the error?").font(textFont) + Text("""
                                                                                                                                                                                        
                                        
                                        
                                        Gradient descent is like a ball rolling down a hill, it wont be able to climb out of a local minima.
                                        """).font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 1  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(1)
                                    
                                    Group {
                                        Text("""
                                        To resolve this problem, we can adjust the learning rate, a number that controls the magnitude of each step.
                                        
                                        
                                        Adjust the slider below and experiment with different learning rates.
                                        """).font(textFont)
                                        
                                    }.padding()
                                        .opacity(cardIndex > 2  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(2)
                                    
                                    Group {
                                        
                                        Slider(value: $learningRateIndx, in: 1.0...4.0, onEditingChanged: { editing in
                                            // todo [0.001,0.005,0.01,0.10,]
                                            // default is 0.005
                                            if Int(round(learningRateIndx)) == 1 {
                                                self.learningRate = 0.001
                                                self.learningRateIndx = 1
                                            } else if Int(round(learningRateIndx)) == 2 {
                                                self.learningRate = 0.005
                                                self.learningRateIndx = 2
                                            } else if Int(round(learningRateIndx)) == 3 {
                                                self.learningRate = 0.01
                                                self.learningRateIndx = 3
                                            } else {
                                                self.learningRate = 0.1
                                                self.learningRateIndx = 4
                                            }
                                        }).padding()
                                        
                                        HStack{
                                            Spacer()
                                            Text(String(format: "Learning rate: %.3f", learningRate))
                                                .font(.system(size: 14).monospaced())
                                                .padding()
                                            Spacer()
                                        }
                                    }
                                    .opacity(cardIndex > 2 ? 1 : 0)
                                    .id(2)
                                    
                                    Group {
                                        Text("""
                                                                                    
                                             As you can see, higher learning rate can let the model explore more of the feature space but risks skipping over the minimum possible.
                                             
                                             
                                             """).font(textFont) + Text("You finished this module on learning rates!").font(boldedTextFont) + Text(" Let's move onto some examples that are even more fun!").font(textFont)
                                        
                                    }.padding()
                                        .opacity(cardIndex > 3  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(3)
                                    
                                    
                                    Spacer()
                                    
                                    
                                }
                                
                                .onChange(of: self.cardIndex) { _ in
                                    withAnimation(.easeInOut) {
                                        value.scrollTo(self.cardIndex - 1, anchor: .top)
                                    }
                                }
                            }
                        }
                        if cardIndex <= 3 {
                            Button(action: {
                                if self.cardIndex < 4 {
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
                        if self.cardIndex > 3 {
                            Button(action: {
                                withAnimation(.spring()) {
                                    self.zoomedOut = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    withAnimation(.spring()) {
                                        self.selectedView = .learn3DGDView
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                    withAnimation(.spring()) {
                                        self.zoomedOut = false
                                    }
                                }
                            }, label: {
                                Text("Go to Multidimensional Module")
                                    .font(.system(size: 23)
                                        .bold()
                                        .monospaced())
                                    .padding()
                                    .padding(.bottom)
                                    .padding(.bottom)
                                    .irregularGradient(colors: [Color("bg5"),Color("bg3"),Color("bg4")])
                                    .scaleEffect(self.time % 2 == 0 ? 1 : 1.1)
                                    .animation(.easeInOut(duration: 1), value: self.time)
                            })
                        }
                    }
                    
                    // intearctive stuff !!!
                    HStack {
                        ComplexInteractiveGraph2DView(cardIndex: $cardIndex, xValue: $xValue, learningRateIndx: $learningRateIndx)
                            .opacity(self.hideOverlayLine ? 1 : 0)
                            .animation(.default, value: self.hideOverlayLine)
                    }
                }
                .padding(.top)
                .padding()
            }
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
