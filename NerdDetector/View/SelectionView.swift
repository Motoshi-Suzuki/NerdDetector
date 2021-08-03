//
//  ContentView.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/10.
//

import SwiftUI

struct SelectionView: View {
    
    @State private var feelinGoodArray: [Bool] = [false, false]
    @State private var showAlert = false
    @State private var moveToHomeView = false
    let userAttribute = UserAttribute()
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(footer: Text("Choose the option that represents your current condition.")) {
                        conditionButtons(feelinGoodArray: $feelinGoodArray)
                    }
                }
                
                OKButton(feelinGoodArray: $feelinGoodArray, showAlert: $showAlert, moveToHomeView: $moveToHomeView)
            
                NavigationLink(destination: HomeView(), isActive: $moveToHomeView) {
                    EmptyView()
                }
            }
            .navigationBarTitle(Text("How are you feeling?"))
        }
        .onAppear(perform: {
            if let feelinGood = UserDefaults.standard.array(forKey: "feelinGoodArray") {
                self.feelinGoodArray = feelinGood as! [Bool]
                userAttribute.setAttribute(feelinGoodArray: self.feelinGoodArray)
                userAttribute.printMessage(messageForGood: "This user is feeling good.",
                                           messageForBad: "This user is feeling bad.")
            } else {
                print("Welcome to EmotionFinder.")
            }
        })
    }
}

struct conditionButtons: View {
    @Binding var feelinGoodArray: [Bool]
    let userAttribute = UserAttribute()
    
    var body: some View {
        Button(action: {
            self.feelinGoodArray = [true, false]
            userAttribute.setAttribute(feelinGoodArray: self.feelinGoodArray)
        }, label: {
            HStack {
                Text("Not bad !!")
                    .foregroundColor(.primary)
                Spacer()
                if self.feelinGoodArray == [true, false] {
                    Image(systemName: "checkmark.circle")
                }
            }
        })
        
        Button(action: {
            self.feelinGoodArray = [false, true]
            userAttribute.setAttribute(feelinGoodArray: self.feelinGoodArray)
        }, label: {
            HStack {
                Text("Not so good.")
                    .foregroundColor(.primary)
                Spacer()
                if self.feelinGoodArray == [false, true] {
                    Image(systemName: "checkmark.circle")
                }
            }
        })
    }
}

struct OKButton: View {
    
    @Binding var feelinGoodArray: [Bool]
    @Binding var showAlert: Bool
    @Binding var moveToHomeView: Bool
    let userAttribute = UserAttribute()
    
    var body: some View {
        Button(
            action: {
                guard self.feelinGoodArray != [false, false] else {
                    self.showAlert = true
                    return
                }
                
                self.moveToHomeView = true
                
                let savedArray = UserDefaults.standard.array(forKey: "feelinGoodArray")
                if savedArray == nil || self.feelinGoodArray != savedArray as! [Bool] {
                    UserDefaults.standard.set(self.feelinGoodArray, forKey: "feelinGoodArray")
                    userAttribute.printMessage(messageForGood: "User saved his/her condition as 'Good'.",
                                               messageForBad: "User saved his/her condition as 'bad'.")
                }
            },
            label: {
                BasicButton(text: "OK")
            }
        )
        .alert(isPresented: $showAlert, content: {
            Alert(
                title: Text("No Option Selected"),
                message: Text("Please select one option.")
            )
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView()
        SelectionView().preferredColorScheme(.dark)
    }
}
