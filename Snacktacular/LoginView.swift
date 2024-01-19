//
//  ContentView.swift
//  Snacktacular
//
//  Created by Christian Manzaraz on 19/01/2024.
//

import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDissabled = true
    
    @FocusState private var focusField: Field?
    
    var body: some View {
        NavigationStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
            
            Group {
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email) // this field is bound to the .email case
                    .onSubmit { // Move from email field to passwordfield
                        focusField = .password
                    }
                    .onChange(of: email) {
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password) // this field is bound to the .password case
                    .onSubmit { // Dismiss keyboard after Done
                        focusField = nil
                    }
                    .onChange(of: password) {
                        enableButtons()
                    }
                
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                
                Button {
                    login()
                } label: {
                    Text("Log In")
                }
                .padding(.leading)
            }
            .disabled(buttonDissabled)
            .buttonStyle(.borderedProminent)
            .tint(Color("SnackColor"))
            .font(.title2)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    func enableButtons() {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailIsGood = NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
        
        let passwordIsGood = password.count >= 6
        buttonDissabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {// login error occurred
                print("😡SIGN-IN ERROR: \(error.localizedDescription)")
                alertMessage = "😡LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎 Registration Success!")
                // TODO: Load ListView
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "😡SIGNUP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎 Login SuccessFULL!")
                // TODO: Load ListView
            }
        }
    }
}

#Preview {
    LoginView()
}
