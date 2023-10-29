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
    var service = FireBaseService.shared
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    HStack{
                        Text("Link")
                            .font(.system(size: 70))
                            .fontDesign(.rounded)
                           .frame(height: 70)
                           .padding()
                        Image(systemName: "link")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .foregroundColor(Color.green)
                        
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
                                .background(.green)
                                .cornerRadius(10)
                                .buttonStyle(.plain)
                        }
                        .padding()
                    }
                    Spacer()
                    NavigationLink(
                        destination: RegisterView(),
                        label: {
                            Text("Don't have an account? **Sign Up** ")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    )
                    .buttonStyle(.plain)
                }
            }
        }
    }
}


#Preview {
    OpenView()
}
