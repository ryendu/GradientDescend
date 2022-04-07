//
//  File.swift
//  
//
//  Created by Ryan D on 4/6/22.
//

import Foundation
import SwiftUI

struct InteractiveWindow: View {
    
    @Binding var slide: Int
    let content: [AnyView]
    
    init<Views>(slide: Binding<Int>, @ViewBuilder content: @escaping () -> TupleView<Views>) {
        self.content = content().getViews
        self._slide = slide
    }
    
    
    var body: some View {
        ZStack {
            //background
            Color.white
            
            content[self.slide]
            
        }
        .overlay(ControlsCard(slide:$slide, maxSlides: content.count - 1),alignment: .bottomLeading)
    }
}



struct ControlsCard: View {
    @Binding var slide: Int
    var maxSlides: Int
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.spring()) {
                if slide - 1 >= 0 {
                    slide -= 1
                }
                }
            }, label: {
                Image(systemName: "chevron.backward.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color("bg4"))
//                    .softOuterShadow()
                    .padding()
            })
            
            Button(action: {
                withAnimation(.spring()) {
                if slide + 1 <= maxSlides {
                    slide += 1
                }
                }
            }, label: {
                Image(systemName: "chevron.forward.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color("bg4"))
//                    .softOuterShadow()
                    .padding()
            })
        }.padding().padding(.bottom)
    }
}

