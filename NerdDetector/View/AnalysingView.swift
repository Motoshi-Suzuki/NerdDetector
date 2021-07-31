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
    @State private var showingResultView = false
    @Binding var showingAnalysingView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Analysing...")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Spacer()
                
                LottieView(animationNumber: $animationNumber)
                    .frame(height: 500)
                
                Spacer()
                
                NavigationLink(destination: ResultView(showingAnalysingView: $showingAnalysingView, animationNumber: $animationNumber),
                               isActive: $showingResultView) {
                    EmptyView()
                }
            }
        }
        .onAppear {
            self.animationNumber += 1
            
            if self.animationNumber > 16 {
                self.animationNumber = 0
            }
            
            UserDefaults.standard.set(self.animationNumber, forKey: "animationNumber")
        }
        
        .onReceive(NotificationCenter.default.publisher(for: .detectFacesFinished), perform: { _ in
            if SharedInstance.noFaceDetected != false {
                self.animationNumber = 100
            } else if SharedInstance.failedToDetectFaces != false {
                self.animationNumber = 404
            }
            self.showingResultView = true
        })
    }
}

struct AnalysingView_Previews: PreviewProvider {
    @State static var showingAnalysingView = true
    static var previews: some View {
        AnalysingView(showingAnalysingView: $showingAnalysingView)
        AnalysingView(showingAnalysingView: $showingAnalysingView).preferredColorScheme(.dark)
    }
}
