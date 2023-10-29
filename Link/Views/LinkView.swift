//
//  LinkView.swift
//  Link
//
//  Created by Nathan Cree on 10/28/23.
//

import Observation
import SwiftUI

struct LinkView: View {
    @Binding var currentScreen: Screen
    @StateObject var vm: NIService

    var notClose: Bool {
        guard let feet = vm.feetAway else { return true }

        return feet > 0.5
    }

    var circleScale: CGFloat {
        guard let feet = vm.feetAway else { return 0.0 }

        if notClose {
            return 0.0
        }
        return CGFloat(feet * 2 + 0.5)
    }

    var backgroundColor: Color {
        return notClose ? .gray : .green
    }

    var body: some View {
        ZStack {
            ColorBackground(color: backgroundColor)
                .animation(.easeInOut, value: backgroundColor)
            if vm.inSession {
                finder
            }
        }
    }

    var finder: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Linking with")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text(vm.peerDisplayName ?? "No one found yet")
                        .font(.title)
                }
                Spacer()
            }

            Text("\(vm.feetString ?? "0") ft away")
                .font(.title)
                .padding(50)
            Spacer()
            // Arrow animation
            ZStack {
                Image(systemName: "arrow.up")
                    .resizable()
                    .rotationEffect(.degrees(Double(vm.rotationAmount ?? 0)))
                    .scaledToFit()
                    .padding()
                    .frame(width: 150)
                    .scaleEffect(notClose ? 1 : 0)
                    .opacity(notClose ? 1 : 0)
                    .animation(.easeInOut, value: notClose)
                    .animation(.easeInOut, value: vm.rotationAmount)

                Image(systemName: "circle.fill")
                    .resizable()
                    .foregroundStyle(.regularMaterial)
                    .shadow(radius: 10)
                    .padding()
                    .scaledToFit()
                    .frame(width: 250)
                    .scaleEffect(circleScale)
                    .animation(.easeInOut, value: circleScale)
            }

            Spacer()
            StatusIndicator(isConnected: vm.inSession)
        }
        .padding()
    }
}

struct StatusIndicator: View {
    var isConnected: Bool

    var body: some View {
        Capsule()
            .fill(Color.secondary.opacity(0.1))
            .frame(height: 60)
            .shadow(color: .gray, radius: 4, x: 0, y: 2)
            .overlay(
                HStack(spacing: 10) {
                    Image(systemName: isConnected ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isConnected ? Color.white.opacity(0.5) : Color.gray)
                        .imageScale(.medium)

                    Text(isConnected ? "Connected" : "Disconnected")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            )
            .padding(.horizontal, 80)
    }
}

struct ColorBackground: View {
    var color: Color

    var body: some View {
        LinearGradient(colors: [color.opacity(0.2), color], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

#Preview {
    LinkView(currentScreen: .constant(.link), vm: .init())
}
