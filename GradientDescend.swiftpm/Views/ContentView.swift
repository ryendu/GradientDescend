//
//  ContentView.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import SwiftUI

struct ContentView: View {
    @State var skipOnboarding = false
    @State var finishedOnboarding = false
    var body: some View {
        VStack{
            if self.skipOnboarding || self.finishedOnboarding{
                TabView()
            } else {
                OnboardingView(finishedOnboarding: self.$finishedOnboarding)
            }
        }.onAppear(perform: {
            self.skipOnboarding = UserDefaults.standard.bool(forKey: "skipOnboarding")
            UserDefaults.standard.set(true, forKey: "skipOnboarding")
        })
    }
}
