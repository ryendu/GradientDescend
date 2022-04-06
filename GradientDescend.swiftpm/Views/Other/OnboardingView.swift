//
//  File.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Binding var finishedOnboarding: Bool
    var body: some View {
        VStack{
            Text("Onboarding")
            Spacer()
            Button(action: {
                self.finishedOnboarding.toggle()
            }, label: {
                Text("Finish Onboarding")
            }).padding()
        }
    }
}
