//
//  ContentView.swift
//  Link
//
//  Created by David Williams on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DirectionsView(vm: DummyViewModel())
    }
}

#Preview {
    ContentView()
}
