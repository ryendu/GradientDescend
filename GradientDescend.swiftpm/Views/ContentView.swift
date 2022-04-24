//
//  ContentView.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var skipOnboarding = true
    @State var finishedOnboarding = false
    @State var player: AVAudioPlayer? = nil
    var body: some View {
        ZStack{
            if !self.skipOnboarding || self.finishedOnboarding{
                TabView()
            } else {
                OnboardingView(finishedOnboarding: self.$finishedOnboarding)
            }
        }.onAppear(perform: {
            self.skipOnboarding = UserDefaults.standard.bool(forKey: "skipOnboarding")
            UserDefaults.standard.set(true, forKey: "skipOnboarding")
//            FontBlaster.blast()
//            print(FontBlaster.loadedFonts)
            
            //play intro
            let url = Bundle.main.url(forResource: "intro", withExtension: "m4a")
            player = try! AVAudioPlayer(contentsOf: url!)
            player!.play()
        })
        .preferredColorScheme(.light)
    }
}
