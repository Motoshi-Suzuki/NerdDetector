//
//  HomeView.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/12.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    
    @ObservedObject var imageClass = ImageClass()
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var showingCameraPicker = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                ImageView(image: $imageClass.image,
                          showingActionSheet: $showingActionSheet,
                          showingImagePicker: $showingImagePicker,
                          showingCameraPicker: $showingCameraPicker)
                
                VStack(spacing: 30) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        CircleButton(text: "ANALYZE")
                    })
                    
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("< Back to Setting")
                    })
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Nerd Detector", displayMode: .inline)        
    }
}

struct ImageView: View {
    
    @Binding var image: Image?
    @Binding var showingActionSheet: Bool
    @Binding var showingImagePicker: Bool
    @Binding var showingCameraPicker: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.secondary)
                .frame(height: 420)
            
            if image != nil {
                image?
                    .resizable()
                    .scaledToFit()
                    .frame(height: 420)
            } else {
                Text("Tap to select a picture")
                    .foregroundColor(.white)
                    .font(.title2)
            }
        }
        .onTapGesture {
            self.showingActionSheet = true
        }
        .actionSheet(isPresented: $showingActionSheet, content: {
            ActionSheet(title: Text("Select an option below"),
                        message: Text("Choose a picture from Photo Library or take a new picture."),
                        buttons: [
                            .default(Text("Photo Library"), action: {
                                self.showingImagePicker = true
                            }),
                            .default(Text("Camera"), action: {
                                self.showingCameraPicker = true
                            }),
                            .cancel()
                        ])
        })
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker(image: $image)
        })
        .sheet(isPresented: $showingCameraPicker, content: {
            CameraPicker(image: $image)
        })
    }
}

class ImageClass: ObservableObject {
    @Published var image: Image?
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        HomeView().preferredColorScheme(.dark)
    }
}
