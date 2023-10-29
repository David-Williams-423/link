//
//  FriendRequestCellView.swift
//  Link
//
//  Created by David Williams on 10/29/23.
//

import SwiftUI

struct FriendRequestCellView: View {
    var requesterName: String
    @State private var requestAccepted: Bool = false

    var body: some View {
        HStack {
            Image("profile_placeholder") // Placeholder for the user's profile image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.leading, 10)

            Text(requesterName)
                .font(.headline)
                .padding(.leading, 10)

            Spacer()

            if requestAccepted {
                Text("Accepted")
                    .foregroundColor(.green)
                    .padding(.trailing, 10)
            } else {
                Button(action: {
                    requestAccepted = true
                }) {
                    Text("Accept")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }
                .padding(.trailing, 10)
            }
        }
        .frame(height: 70)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct FriendRequestCellView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestCellView(requesterName: "John Doe")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


#Preview {
    FriendRequestCellView(requesterName: "David")
}
