//
//  DirectionsView.swift
//  Link
//
//  Created by Lauren Ferlito on 10/28/23.
//

import SwiftUI

struct DirectionsView: View {
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
                HStack {
                    Text("\(vm.alecNipp.distanceAway)")
                        .font(.largeTitle)
                    Text("ft away")
                        .font(.largeTitle)
                }
                arrowImage
                Spacer()
            }
        }
    }
    
    var background: some View {
        LinearGradient(colors: [.gray.opacity(0.8), .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    var arrowImage: some View {
        let direction = vm.alecNipp.direction

        switch direction {
            case .ahead:
                return Image(systemName: "arrow.up")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150)
            case .behind:
                return Image(systemName:  "arrow.down")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150)
            case .aheadRight:
                return Image(systemName: "arrow.up.right")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150)
            case .aheadLeft:
                return Image(systemName: "arrow.up.left")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150)
            case .left:
                return Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150)
            case .right:
                return Image(systemName: "arrow.right")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150)
            case .behindLeft:
                return Image(systemName: "arrow.down.left")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150)
            case .behindRight:
                return Image(systemName: "arrow.down.right")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150)
        }
    }
}

#Preview {
    DirectionsView(vm: DummyViewModel())
}
