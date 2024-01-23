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
    @State private var showPassword = false
    @State private var path = NavigationPath()
    
    @FocusState private var focusField: Field?
    
    var body: some View {
        NavigationStack(path: $path) {
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
                
                HStack {
                    if showPassword {
                        TextField("Password", text: $password)
                            .textInputAutocapitalization(.never)
                            .submitLabel(.done)
                            .focused($focusField, equals: .password) // this field is bound to the .password case
                            .onSubmit { // Dismiss keyboard after Done
                                focusField = nil
                            }
                            .onChange(of: password) {
                                enableButtons()
                            }
                    } else {
                        SecureField("Password", text: $password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .submitLabel(.done)
                            .focused($focusField, equals: .password) // this field is bound to the .password case
                            .onSubmit { // Dismiss keyboard after Done
                                focusField = nil
                            }
                            .onChange(of: password) {
                                enableButtons()
                            }
                    }
                    
                    Button {
                        self.showPassword.toggle()
                    } label: {
                        Image(systemName: self.showPassword ? "eyebrow": "eye")
                            .foregroundStyle(Color("SnackColor"))
                            .padding(.horizontal)
                    }
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
            .navigationDestination(for: String.self) { view in
                if view == "ListView" {
                    ListView()
                }
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            // if logged in when app runs, navigate to the new screen & skip login screen
            if Auth.auth().currentUser != nil {
                print("🪵⬅️ Login Successful!")
                path.append("ListView")
            }
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
                path.append("ListView")
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
                print("🪵⬅️ Login SuccessFULL!")
                path.append("ListView")
            }
        }
    }
}

#Preview {
    LoginView()
}
