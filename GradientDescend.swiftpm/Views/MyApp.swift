//
//  File.swift
//  GradientDescend
//
//  Created by Ryan D on 4/5/22.
//

import SwiftUI
import FontBlaster

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    FontBlaster.blast()
                    print(FontBlaster.loadedFonts)
                }
        }
    }
}
