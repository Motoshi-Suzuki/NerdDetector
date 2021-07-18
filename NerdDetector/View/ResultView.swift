//
//  ResultView.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/18.
//

import SwiftUI

struct ResultView: View {
    
    @Binding var showingAnalysingView: Bool
    
    var body: some View {
        Button(action: {
            self.showingAnalysingView = false
        }, label: {
            Text("Back to HomeView")
        })
        .navigationBarHidden(true)
    }
}

struct ResultView_Previews: PreviewProvider {
    @State static var showingAnalysingView = true
    static var previews: some View {
        ResultView(showingAnalysingView: $showingAnalysingView)
        ResultView(showingAnalysingView: $showingAnalysingView).preferredColorScheme(.dark)
    }
}
