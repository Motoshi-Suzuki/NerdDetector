//
//  LottieView.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/17.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    @Binding var animationNumber: Int
    var animationView = AnimationView()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: LottieView
        
        init(_ parent: LottieView) {
            self.parent = parent
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        animationView.animation = Animation.named(String(animationNumber))
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play()
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
}
