//
//  Article.swift
//  Financy
//
//  Created by Adriana Zambrano on 1/28/24.
//

import SwiftUI

struct Article: View {
    @State var url = URL(string: "")
    var body: some View {
        Text("Learn Finacial Literacy")
            .font(.largeTitle.weight(.bold))
            .multilineTextAlignment(.center)
            .padding()
        List {
            NavigationLink(destination: EmergencyFunds()) {
                Text("Emergency Funds")
            }
            NavigationLink(destination: Investments()) {
                Text("Investments")
            }
        }
        .listStyle(.inset)
    }
}
#Preview {
    Article()
}
