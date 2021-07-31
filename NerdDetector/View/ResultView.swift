//
//  ResultView.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/18.
//

import SwiftUI

struct ResultView: View {
    
    @Binding var showingAnalysingView: Bool
    @State private var resultImage: Image?
    @State private var message: String?
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                ResultImageView(resultImage: $resultImage)
                
                VStack(spacing: 10) {
                    Text(self.message ?? "You are xxx.")
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text("Positiveness  \(SharedInstance.positiveScore)")
                            .font(.body)
                        Text("Negativeness  \(SharedInstance.negativeScore)")
                            .font(.body)
                    }
                }
            }
            .padding(.bottom, 70)
        }
        .onAppear(perform: {
            let userAttribute = UserAttribute()
            self.message = userAttribute.showMessage()
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                self.showingAnalysingView = false
            }, label: {
                Image(systemName: "xmark")
            })
        )
    }
}

struct ResultImageView: View {
    @Binding var resultImage: Image?
    
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
                Text("Oops...something went wrong.")
                    .foregroundColor(.white)
                    .font(.title2)
            }
        }
        .onAppear(perform: {
            self.resultImage = Image(uiImage: SharedInstance.resultUiImage)
        })
    }
}

struct ResultView_Previews: PreviewProvider {
    @State static var showingAnalysingView = true
    static var previews: some View {
        ResultView(showingAnalysingView: $showingAnalysingView)
        ResultView(showingAnalysingView: $showingAnalysingView).preferredColorScheme(.dark)
    }
}
