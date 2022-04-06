//
//  SupportingViews.swift
//  
//
//  Created by Ryan D on 4/5/22.
//

import Foundation
import SwiftUI



// code from https://www.fivestars.blog/articles/conditional-modifiers/
// I used this snippet because this simple extension to view makes it a lot more
// convenient to deal with modifying views conditionally and prevents duplicate code.
extension View {
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(_ condition: Bool, if ifTransform: (Self) -> TrueContent, else elseTransform: (Self) -> FalseContent) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
