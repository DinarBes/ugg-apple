//
//  InitiateView.swift
//  template-kit
//

import SwiftUI

struct InitiateView<Action: View>: View {
    @Binding var phone: String
    var error: String?
    @ViewBuilder var action: Action

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            TextField("Phone", text: $phone)
                .textContentType(.telephoneNumber)
                .keyboardType(.phonePad)

            if let error {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            action
        }
        .padding()
    }
}
