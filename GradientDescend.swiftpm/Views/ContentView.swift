//
//  ContentView.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import SwiftUI
import AVFoundation


/*
 Hey There! 👋

 I'm Ryan, welcome to my swift playground app, GradientDescend,
 where we will descend into how Gradient Descent work!
 
 **GradientDescend** is best experienced full screen in landscape.
 The build process might take a moment so hold tight enjoy!
 
*/




struct ContentView: View {
    @State var finishedOnboarding = false
    @State var player: AVAudioPlayer? = nil
    var body: some View {
        ZStack{
            if self.finishedOnboarding{
                TabView()
            } else {
                OnboardingView(finishedOnboarding: self.$finishedOnboarding)
            }
        }.onAppear(perform: {
            //play intro
            let url = Bundle.main.url(forResource: "intro", withExtension: "m4a")
            player = try! AVAudioPlayer(contentsOf: url!)
            player!.play()
        })
        .preferredColorScheme(.light)
    }
}
