//
//  HomeView.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/12.
//

import SwiftUI

struct HomeView: View {
    
    let preparation = DetectFacesPreparation()
    @ObservedObject var imageClass = ImageClass()
    @Environment(\.presentationMode) var presentation
    
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var showingCameraPicker = false
    @State private var showingAnalysingView = false
    
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
                    Button(action: {
                        if imageClass.image != nil {
                            self.showingAnalysingView = true
                            preparation.prepareForDetectFaces()
                        } else {
                            print("Parameter 'uiImage' is nil.")
                        }
                    }, label: {
                        CircleButton(text: "ANALYSE")
                    })
                    
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("< Back to Setting")
                    })
                }
            }
        }
        .fullScreenCover(isPresented: $showingAnalysingView, content: {
            AnalysingView(showingAnalysingView: $showingAnalysingView)
        })
        
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
                VStack(spacing: 40) {
                    Image(systemName: "person.crop.rectangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .foregroundColor(Color(.tertiarySystemGroupedBackground))
                    
                    Text("Tap to select a picture with your face")
                        .foregroundColor(.white)
                        .font(.title2)
                }
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
                                self.showingActionSheet = false
                                self.showingImagePicker = true
                            }),
                            .default(Text("Camera"), action: {
                                self.showingActionSheet = false
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        HomeView().preferredColorScheme(.dark)
    }
}
