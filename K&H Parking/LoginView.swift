//
//  LoginView.swift
//  K&H Parking
//
//  Created by Nara Csutora on 2023. 02. 24..
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    var slp: Binding<Bool>
    var pc = PersistenceController()
    var ah = AuthenticationHandler()
    init(slp: Binding<Bool>) {
        self.slp = slp
    }
    

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image("layered-waves-haikei")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top)
                Image("knh")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top)
            }
            
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    Spacer()
                        .padding(.horizontal)
                    VStack {
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom)
                        
                        
                        Button(action: {
                            loginButton()
                        }) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: {print("")}) {
                           Text("Forgot password")
                                .font(.footnote)
                        }
                        
                        
                        
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(15)
                    .frame(minWidth: 300)
                    Spacer()
                        .padding(.horizontal)
                }
                .padding(.top)
                
               
                
                
                Spacer()
                    .padding(.vertical)
            }
            .background(Color(red: 21/255, green: 57/255, blue: 103/255))
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        
        
        
    }
    
    
    func loginButton() {
        Task {
            await ah.login(email: $email.wrappedValue, password: $password.wrappedValue)
            if ah.token != nil {
                let user = User(name: ah.name!, licensePlates: ah.licensePlates!, email:$email.wrappedValue, token: ah.token!)
                pc.saveUser(user)
                slp.wrappedValue = false
            }
        }
    }

}


