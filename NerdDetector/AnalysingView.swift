//
//  AnalysingView.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/17.
//

import SwiftUI

struct AnalysingView: View {
    
    // if nil, userDefaults returns 0.
    @State private var animationNumber: Int = UserDefaults.standard.integer(forKey: "animationNumber")
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Analysing...")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Spacer()
            
            LottieView(animationNumber: $animationNumber)
                .frame(height: 500)
            
            Spacer()
        }
        .onDisappear {
            if animationNumber == 9 {
                animationNumber = 0
            } else {
                animationNumber += 1
            }
            UserDefaults.standard.set(animationNumber, forKey: "animationNumber")
        }
    }
}

struct AnalysingView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysingView()
        AnalysingView().preferredColorScheme(.dark)
    }
}
