//
//  OtpView.swift
//  ugg-kit
//

import SwiftUI

struct OtpView<Action: View>: View {
    var phone: String
    @Binding var otp: String
    var error: String?
    @ViewBuilder var action: Action

    var body: some View {
        VStack(spacing: 16) {
            Text("Code sent to \(phone)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("OTP", text: $otp)
                .textContentType(.oneTimeCode)
                .keyboardType(.numberPad)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            if let error {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            action
        }
        .padding()
    }
}
