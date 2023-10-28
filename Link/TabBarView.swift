//
//  TabBarView.swift
//  Link
//
//  Created by Lauren Ferlito on 10/28/23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    //nothing
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.black)
                }
                Spacer()
                Button(action: {
                    //nothing
                }) {
                    Image(systemName: "link")
                        .foregroundColor(.black)
                }
                Spacer()
                Button(action: {
                    //nothing
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15.0)
            
        }
        .padding()
    }
}
#Preview {
    TabBarView()
}
