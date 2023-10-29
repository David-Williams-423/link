//
//  OpenView.swift
//  Link
//
//  Created by AlecNipp on 10/28/23.
//

import SwiftUI

struct OpenView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToNextScreen = false
    var service = FireBaseService()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                greenBackground
                VStack {
                    Spacer()
                    HStack{
                        Text("Link")
                            .font(.system(size: 70))
                           .frame(height: 70)
                           .padding()
                        Image(systemName: "link")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .foregroundColor(Color.black)
                        
                    }
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .padding(.leading)
                    Divider()
                        .padding(.leading)
                        .padding(.trailing)
                    SecureField("Password", text: $password)
                        .padding(.leading)
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: ContentView().navigationBarBackButtonHidden(true),
                            isActive: $navigateToNextScreen,
                            label: {
                                EmptyView()
//
                            }
                        )
                        Button(action: {
                            Task {
                                do {
                                    try await service.signIn(withEmail: email, password: password)
                                    navigateToNextScreen = true
                                    print("Log in worked")
                                    await print(service.currentUser)
                                } catch {
                                    print("Error: \(error)")
                                }
                            }
                        }) {
                            Text("Login")
                                .font(.footnote)
                                .foregroundColor(.black)
                                .padding(.top, 7)
                                .padding(.bottom, 7)
                                .padding(.trailing, 10)
                                .padding(.leading, 10)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    Spacer()
                    NavigationLink(
                        destination: RegisterView(),
                        label: {
                            Text("Don't have an account? **Sign Up** ")
                                .font(.footnote)
                                .foregroundColor(.black)
                        }
                    )
                }
            }
        }
    }
    var greenBackground: some View {
          LinearGradient(colors: [.white.opacity(0.2), .green.opacity(0.9)], startPoint: .top, endPoint: .bottom)
              .ignoresSafeArea()
    }
}


#Preview {
    OpenView()
}
