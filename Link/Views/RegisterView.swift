//
//  RegisterView.swift
//  Link
//
//  Created by AlecNipp on 10/28/23.
//

import SwiftUI

struct RegisterView: View {

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedImage: Image? = nil
    @State private var isImagePickerPresented = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Create Account")
                    .font(.title)
                    .fontDesign(.rounded)
                TextField("First Name", text: $firstName)
                    .padding(.leading)
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                TextField("Last Name", text: $lastName)
                    .padding(.leading)
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding(.leading)
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                SecureField("Password", text: $password)
                    .padding(.leading)
                Divider()
                    .padding(.leading)
                    .padding(.trailing)
                HStack{
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Text("Select Profile Picture")
                            .foregroundColor(.gray)
//                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.leading)
                if let image = selectedImage {
                    image
                        .resizable()
                        .cornerRadius(8.0)
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                } else {
                    Text("")
                }
                HStack {
                    Spacer()
                    NavigationLink(
                        destination: ContentView().navigationBarBackButtonHidden(true),
                        label: {
                            //                        Button(action: {
                            //                            // save stuff later
                            //
                            //                        }) {
                            Text("Sign Up")
                                .font(.footnote)
                                .padding(.top, 7)
                                .padding(.bottom, 7)
                                .padding(.trailing, 10)
                                .padding(.leading, 10)
                                .background(.green)
                                .cornerRadius(10)
                        }
                        //                    }
                    )
                    .buttonStyle(.plain)
                    .padding()

                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }
        }
        .navigationBarBackButtonHidden(true)
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
    RegisterView()
}
