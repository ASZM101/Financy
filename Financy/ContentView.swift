//
//  ContentView.swift
//  Financy
//
//  Created by Adriana Zambrano on 1/27/24.
//

import SwiftUI

struct ContentView: View {
    @State var budget: Double = 0.0
    @State var withdrawals: Double = 0.0
    @State var deposits: Double = 0.0
    @State var isExpense: Bool = false
    @State var entries = [""]
    @State var clear = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Balance: $" + String(budget))
                    .font(.largeTitle.weight(.bold))
                ProgressView(value: withdrawals, total: deposits)
                    .progressViewStyle(.linear)
                    .padding()
                HStack {
                    Text("$" + String(withdrawals) + "\nwithdrawn")
                        .font(.title3.weight(.semibold))
                    Spacer()
                    Text("$" + String(deposits) + "\ndeposited")
                        .font(.title3.weight(.semibold))
                }
                .padding()
                .multilineTextAlignment(.center)
                
                List {
                    if entries[0] == "" && entries.count == 1 {
                        HStack {
                            Spacer()
                            Text("No entries")
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    } else {
                        ForEach(entries, id: \.self) { entry in
                            Text(entry)
                        }
                    }
                }
                .listStyle(.inset)
                HStack {
                    NavigationLink(destination: NewEntry(budget: $budget, withdrawals: $withdrawals, deposits: $deposits, isExpense: .constant(false), entries: $entries)) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button {
                        clear = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color("darkGrey"))
                    }
                    .alert("Are you sure you want to erase all your entries and reset your balance?", isPresented: $clear) {
                        Button("Yes", role: .destructive) {
                            entries = [""]
                            withdrawals = 0.0;
                            deposits = 0.0;
                            budget = 0.0
                        }
                        Button("No", role: .cancel) {
                            
                        }
                    }
                    Spacer()
                    NavigationLink(destination: NewEntry(budget: $budget, withdrawals: $withdrawals, deposits: $deposits, isExpense: .constant(true), entries: $entries)) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }
            .onAppear() {
                budget = deposits - withdrawals
            }
        }
    }
}

#Preview {
    ContentView()
}
