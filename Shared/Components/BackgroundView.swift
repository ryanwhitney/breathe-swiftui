//
//  BackgroundView.swift
//  breathe-swiftui
//

import SwiftUI

struct BackgroundView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        LinearGradient(
            colors: [Color("blueTop"), Color("blueBottom")],
            startPoint: .top, endPoint: .bottom)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
