//
//  LoadingView.swift
//  Link
//
//  Created by David Williams on 10/29/23.
//


import SwiftUI

struct LoadingView: View {
    @State private var isAuthenticated: Bool?

    var body: some View {
        Group {
            if isAuthenticated == nil {
                // While loading, display a progress view
                ProgressView()
            } else if isAuthenticated == true {
                // If authenticated, show the content view
                ContentView()
            } else {
                // If not authenticated, show the login view
                OpenView()
            }
        }
        .onAppear {
            // Check authentication status on view appear
            checkAuthentication()
        }
    }

    private func checkAuthentication() {
        // Use Firebase to check if the user is authenticated
        Task {
            do {
                isAuthenticated = try await FireBaseService.shared.fetchUser()
            } catch {
                isAuthenticated = false
            }
            
        }
        
    }
}


#Preview {
    LoadingView()
}
