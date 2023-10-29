//
//  LinkView.swift
//  Link
//
//  Created by Nathan Cree on 10/28/23.
//

import SwiftUI
import Observation

struct LinkView: View {
    @Binding var selectedTab: Tabs
    @StateObject var vm: NIService
    var body: some View {
        ZStack {
            // make 5 ft instead - small number for testing
            if (vm.distanceAway ?? 6 > 0.5) {
                grayBackground
            } else {
                greenBackground
            }
            VStack {
                HStack {
                    VStack(alignment:.leading) {
                        Text("Linking with")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Text(vm.peerDisplayName ?? "No one found yet")
                            .font(.title)
                    }
                    Spacer()
                    Button {
                        // nothing yet
                    } label: {
                        Text("Cancel")
                            .font(.footnote)
                    }
                }
                Spacer()
                Text("\(vm.distanceAway ?? 0) ft away")
                    .font(.title)
                Image(systemName: vm.monkeyLabel)
                    .resizable()
                    .rotationEffect(.degrees(Double(vm.rotationAmount ?? 0)))
                // rotation efect does not seem to work. Need to multiply by 360?
                   .scaledToFit()
                   .padding()
                   .frame(width: 150)
                Spacer()
                Text("Status: \(vm.informationLabel)")
                Spacer()
            }
            .padding()
            TabBarView(selectedTab: $selectedTab)
        }
    }
    var grayBackground: some View {
          LinearGradient(colors: [.gray.opacity(0.8), .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
              .ignoresSafeArea()
      }
    
    var greenBackground: some View {
          LinearGradient(colors: [.white.opacity(0.2), .green.opacity(0.9)], startPoint: .top, endPoint: .bottom)
              .ignoresSafeArea()
      }
}

#Preview {
    LinkView()
}
