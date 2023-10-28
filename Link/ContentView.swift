//
//  ContentView.swift
//  Link
//
//  Created by David Williams on 10/28/23.
//

import SwiftUI
import Observation

struct ContentView: View {
    
    var niDelegate = NIService()
    var body: some View {
        VStack {
            Text(niDelegate.peerDisplayName ?? "No one found yet")
            Text(niDelegate.informationLabel)
            Text(niDelegate.monkeyLabel)
                .rotationEffect(.degrees(Double(niDelegate.rotationAmount ?? 0)))
            Text("\(niDelegate.distanceAway ?? 0)")
        }
        .padding()
        .onAppear() {
            niDelegate.startup()
        }
    }
}

#Preview {
    ContentView()
}
