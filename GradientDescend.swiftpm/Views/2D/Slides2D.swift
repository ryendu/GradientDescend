//
//  File.swift
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
                                        Text("Say we have a model with just ").font(textFont) + Text("one adjustable parameter. ").font(boldedTextFont) + Text("The graph on the right is the graph of its ").font(textFont) + Text("cost function").font(boldedTextFont) + Text(", where the ").font(textFont) + Text("X").font(boldedTextFont) + Text(" axis represents the value of that one adjustable parameter and the ").font(textFont) + Text("Y").font(boldedTextFont) + Text(" axis represents the corresponding error produced by the model with parameter ").font(textFont) + Text("X").font(boldedTextFont) + Text(".").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 0 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(0)
                                    
                                    //when its card index 2, wait 2 seconds and have the animation of the steps
                                    Group {
                                        Text("The model is initialized with an ").font(textFont) + Text("arbitrary starting point").font(boldedTextFont) + Text(" and the Gradient Descent algorithm adjusts the model to decrease the error as much as possible.").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 1  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(1)
                                    
                                    Group {
                                        Text("You try first! Adjust the slider below to get the model to have the lowest error rate").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 2  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(2)
                                    
                                    Slider(value: $xValue, in: 0...10, onEditingChanged: { editing in
                                        if round(xValue) == 5.0 {
                                            self.counter += 1
                                            print("REWARD!!!!!!!")
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
                                        Text("Similar to what you did, gradient descent calculates the ").font(textFont) + Text("derivative").font(boldedTextFont) + Text(" (or slope) of the current point and adjusts the Weights and Biases of the model to take steps in the direction with the ").font(textFont) + Text("steepest downward slope").font(boldedTextFont) + Text(" until it reduces the cost function to the minimum possible (though you probably didn't do calculus in your head). ").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 4 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(5)
                                    
                                    
                                    Group {
                                        Text("To put it in other words, ").font(textFont)
                                        
                                        Text("Given an arbitrary starting point, the gradient descent algorithm will take steps in the direction of the steepest slope until it reaches the bottom. Click Next to see this in action!").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 5 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(6)
                                    
                                    Group {
                                        
                                        //TODO: Seperate the below into two blocks of text
                                        Text("As you can see, as gradient descent gets closer and closer to the minimum, it takes smaller and smaller steps until it has reached the convergence point (lowest point). Now you should have a basic understanding of how gradient descent works! Click next to move on to the next section.").font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 6 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(7)
                                    
                                    Spacer()
                                    
                                    
                                }
                                
                                .onChange(of: self.cardIndex) { _ in
                                    withAnimation(.easeInOut) {
                                        value.scrollTo(self.cardIndex, anchor: .center)
                                    }
                                }
                                
                            }
                        }
                        
                        if cardIndex <= 7 && cardIndex != 3 {
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
                        if self.cardIndex >= 8 {
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
                    
                    // intearctive stuff !!!
                    HStack {
                        SimpleInteractiveGraph2DView(cardIndex: $cardIndex, xValue: $xValue)
                            .opacity(self.hideOverlayLine ? 1 : 0)
                            .animation(.default, value: self.hideOverlayLine)
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
                                        Text("""
                                            Now lets look at a more complex example of gradient descent.
                                            
                                            Here, we have a model with two
                                            """).font(textFont) + Text("local minima").font(boldedTextFont) + Text(" (lowest points), lets run gradient descent just as we did in the pervioius example and observe what happens. ").font(textFont) + Text(" (click next)").font(boldedTextFont)
                                    }.padding()
                                        .opacity(cardIndex > 0 ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(0)
                                    
                                    //when its card index 2, wait 2 seconds and have the animation of the steps
                                    Group {
                                        Text("Did you notice how gradient descent didn't minimize the cost function to the max? This is because it got stuck in a ").font(textFont) + Text("local minima.").font(boldedTextFont) + Text("""
                                                                                                                                                                                                                            
                                        Since gradient descent calculates the derivative of its current position, it'll naturally go towards the downward direction like a ball rolling down a hill. Because of this, the model will get stuck in a local minima during training.
                                        """).font(textFont)
                                    }.padding()
                                        .opacity(cardIndex > 1  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(1)
                                    
                                    Group {
                                        Text("""
                                        To resolve this problem, we can adjust the learning rate, a number multiplied to the negative derivateve of the current point which changes the magnitude of each step. A higher learning rate can let the model explore more of the feature space but risks skipping over the global minima (minimum possible cost function).
                                        
                                        Adjust the slider below and experiment with different learning rates.
                                        """).font(textFont)
                                        
                                    }.padding()
                                        .opacity(cardIndex > 2  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(2)
                                    
                                    Group {
                                        Group {
                                            HStack{
                                                Spacer()
                                                ForEach(0...4, id: \.self) { i in
                                                    Spacer()
                                                    Rectangle().size(width: 2, height: 10)
                                                        .fill()
                                                        .foregroundColor(Color("neutral400"))
//                                                    Spacer()
                                                }
                                            }
                                        }
                                    Slider(value: $learningRateIndx, in: 1.0...5.0, onEditingChanged: { editing in
                                        // todo [0.001,0.005,0.01,0.10,0.1]
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
                                        } else if Int(round(learningRateIndx)) == 4 {
                                            self.learningRate = 0.1
                                            self.learningRateIndx = 4
                                        } else {
                                            self.learningRate = 1
                                            self.learningRateIndx = 5
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
                                        Text("You've finished this module! You did it, you learned about what gradient descent is and you know how it works! Now lets dive into some more fun examples!").font(textFont)
                                        
                                    }.padding()
                                        .opacity(cardIndex > 2  ? 1 : 0)
                                        .animation(.spring(), value: self.cardIndex)
                                        .id(3)
                                    
                                    
                                    Spacer()
                                    
                                    
                                }
                                
                                .onChange(of: self.cardIndex) { _ in
                                    withAnimation(.easeInOut) {
                                        value.scrollTo(self.cardIndex - 1, anchor: .center)
                                    }
                                }
                            }
                        }
                        if cardIndex <= 2 {
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
                        if self.cardIndex > 2 {
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
                    }//.frame(width: (geo?.size.width ?? 100) * 0.4)
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
