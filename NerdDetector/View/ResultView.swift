//
//  ResultView.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/18.
//

import SwiftUI

struct ResultView: View {
    
    @State private var resultImage: Image?
    @State private var message: String?
    @State private var oparationFailed = false
    @Binding var showingAnalysingView: Bool
    @Binding var animationNumber: Int
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                ResultImageView(resultImage: $resultImage, animationNumber: $animationNumber, oparationFailed: $oparationFailed)
                
                VStack(spacing: 5) {
                    Text(oparationFailed ? self.message ?? "" : "It seems you are feeling")
                        .font(.title)
                    Text(oparationFailed ? "" : "\(self.message ?? "").")
                        .font(.largeTitle)
                }
            }
            .padding(.bottom, 70)
        }
        .onAppear(perform: {
            let userAttribute = UserAttribute()
            self.message = userAttribute.showMessage()
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(leading:
            Button(action: {
                self.showingAnalysingView = false
            }, label: {
                Image(systemName: "xmark")
            }))
    }
}

struct ResultImageView: View {
    @Binding var resultImage: Image?
    @Binding var animationNumber: Int
    @Binding var oparationFailed: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.secondary)
                .frame(height: 500)
            
            if resultImage != nil {
                resultImage?
                    .resizable()
                    .scaledToFit()
                    .frame(height: 500)
            } else {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 500)
                
                LottieView(animationNumber: $animationNumber)
                    .frame(height: 500)
            }
        }
        .onAppear(perform: {
            if SharedInstance.failedToDetectFaces != true && SharedInstance.noFaceDetected != true {
                self.resultImage = Image(uiImage: SharedInstance.resultUiImage)
            } else {
                self.oparationFailed = true
            }
        })
    }
}

struct ResultView_Previews: PreviewProvider {
    @State static var showingAnalysingView = true
    @State static var animationNumber: Int = 100
    static var previews: some View {
        ResultView(showingAnalysingView: $showingAnalysingView, animationNumber: $animationNumber)
        ResultView(showingAnalysingView: $showingAnalysingView, animationNumber: $animationNumber).preferredColorScheme(.dark)
    }
}
