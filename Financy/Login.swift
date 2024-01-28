//
//  Login.swift
//  Financy
//
//  Created by Adriana Zambrano on 1/27/24.
//

import SwiftUI

struct Login: View {
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        NavigationView {
            VStack {
                Image("icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .padding(.top)
                Text("Welcome to\nFinancy")
                    .font(.largeTitle.weight(.bold))
                    .multilineTextAlignment(.center)
                    .padding()
                TextField("Username", text: $username)
                    .padding()
                    .background(Color("lightGrey"))
                    .cornerRadius(20)
                    .padding()
                TextField("Password", text: $password)
                    .padding()
                    .background(Color("lightGrey"))
                    .cornerRadius(20)
                    .padding()
                    Button{
                        
                    } label: {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                            HStack {
                                Spacer()
                                Text("Login")
                                Spacer()
                            }
                            .frame(width: 150)
                        }
                    }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(.capsule)
                Spacer()
            }
        }
    }
}

#Preview {
    Login()
}
