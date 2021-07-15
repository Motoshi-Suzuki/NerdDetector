//
//  ButtonDesign.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/14.
//

import SwiftUI

struct BasicButton: View {
    var text: String
    
    var body: some View {
        Text(text)
            .bold()
            .frame(width: 280, height: 50)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
    }
}

struct CircleButton: View {
    var text: String
    
    var body: some View {
        Circle()
            .fill(Color(.secondarySystemGroupedBackground))
            .frame(width: 150, height: 150)
            .overlay(
                RoundedRectangle(cornerSize: CGSize(width: 150, height: 150))
                    .stroke(Color.secondary, lineWidth: 2))
            .overlay(
                Text(text)
                    .font(.title))
    }
}
