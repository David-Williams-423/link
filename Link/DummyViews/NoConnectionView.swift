//
//  NoConnectionView.swift
//  Link
//
//  Created by Lauren Ferlito on 10/28/23.
//

import SwiftUI

struct NoConnectionView: View {
    @ObservedObject var vm: DummyViewModel
    
    var body: some View {
        ZStack {
            background
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Finding")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Text(vm.alecNipp.name)
                            .font(.title)
                    }
                    .padding()
                    Spacer()
                    Button {
                        // nothing yet
                    } label: {
                        Text("Cancel")
                            .font(.footnote)
                    }
                    .padding()
                }
                Spacer()
                Text("Searching for signal...")
                    .fontWeight(.bold)
                Text("Try moving to a new location.")
                Spacer()
            }
        }
    }
    
    var background: some View {
        LinearGradient(colors: [.gray.opacity(0.8), .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

#Preview {
    NoConnectionView(vm: DummyViewModel())
}
