//
//  ContentView.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/10.
//

import SwiftUI

struct SelectionView: View {
    
    @State private var isNerdArray: [Bool] = [false, false]
    @State private var showAlert = false
    @State private var moveToHomeView = false
    @EnvironmentObject var userAttribute: UserAttribute
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(footer: Text("Choose the option that represents your personality.")) {
                        IsNerdButtons(isNerdArray: $isNerdArray)
                    }
                }
                
                OKButton(isNerdArray: $isNerdArray, showAlert: $showAlert, moveToHomeView: $moveToHomeView)
            
                NavigationLink(destination: HomeView(), isActive: $moveToHomeView) {
                    EmptyView()
                }
            }
            .navigationBarTitle(Text("Are you Nerd?"))
        }
        .onAppear(perform: {
            if let isNerd = UserDefaults.standard.array(forKey: "isNerdArray") {
                isNerdArray = isNerd as! [Bool]
                userAttribute.setAttribute(isNerdArray: isNerdArray)
                userAttribute.printMessage(messageForNerd: "This user is Nerd.",
                                           messageForNonNerd: "This user is not Nerd.")
            } else {
                print("Welcome to NerdDetector.")
            }
        })
    }
}

struct IsNerdButtons: View {
    @Binding var isNerdArray: [Bool]
    @EnvironmentObject var userAttribute: UserAttribute
    
    var body: some View {
        Button(action: {
            isNerdArray = [true, false]
            userAttribute.setAttribute(isNerdArray: isNerdArray)
        }, label: {
            HStack {
                Text("Yes, I'm a Nerd !!")
                    .foregroundColor(.primary)
                Spacer()
                if isNerdArray == [true, false] {
                    Image(systemName: "checkmark.circle")
                }
            }
        })
        
        Button(action: {
            isNerdArray = [false, true]
            userAttribute.setAttribute(isNerdArray: isNerdArray)
        }, label: {
            HStack {
                Text("Absolutely I am not a Nerd.")
                    .foregroundColor(.primary)
                Spacer()
                if isNerdArray == [false, true] {
                    Image(systemName: "checkmark.circle")
                }
            }
        })
    }
}

struct OKButton: View {
    
    @Binding var isNerdArray: [Bool]
    @Binding var showAlert: Bool
    @Binding var moveToHomeView: Bool
    @EnvironmentObject var userAttribute: UserAttribute
    
    var body: some View {
        Button(
            action: {
                guard isNerdArray != [false, false] else {
                    showAlert = true
                    return
                }
                
                moveToHomeView = true
                
                let savedIsNerdArray = UserDefaults.standard.array(forKey: "isNerdArray")
                if savedIsNerdArray == nil || isNerdArray != savedIsNerdArray as! [Bool] {
                    UserDefaults.standard.set(isNerdArray, forKey: "isNerdArray")
                    userAttribute.printMessage(messageForNerd: "User saved his/her attribute as 'Nerd'.",
                                               messageForNonNerd: "User saved his/her attribute as 'Non-Nerd'.")
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
            .environmentObject(UserAttribute())
        SelectionView()
            .preferredColorScheme(.dark)
            .environmentObject(UserAttribute())
    }
}
