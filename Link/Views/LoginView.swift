//
//  LoginView.swift
//  Link
//
//  Created by Lauren Ferlito on 10/28/23.
//

import SwiftUI

struct LoginView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedImage: Image? = nil
    @State private var isImagePickerPresented = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section(header: Text("Account Information")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                }

                Section(header: Text("Profile Picture")) {
                    if let image = selectedImage {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                    } else {
                        Text("No Image Selected")
                    }
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Text("Select Profile Picture")
                    }
                }

                Section {
                    Button(action: {
                        // Doing validation here, but would prob store the info somewhere irl and then go to the home view
                        print("First Name: \(firstName)")
                        print("Last Name: \(lastName)")
                        print("Email: \(email)")
                        print("Password: \(password)")
                    }) {
                        Text("Register")
                    }
                }
            }
            .navigationTitle("Registration Form")
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
    }
}

// slect profile picture
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    LoginView()
}
