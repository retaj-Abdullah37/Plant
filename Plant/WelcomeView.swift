//
//  WelcomeView.swift
//  Plant
//
//  Created by Retaj Abdullah on 02/06/1448 AH.
//


import SwiftUI

struct WelcomeView: View {
    let onStart: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {

                // Header
                VStack(alignment: .leading, spacing: 18) {
                    Text("My Plants 🌱")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)

                    Divider()
                        .background(Color.gray.opacity(0.5))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 25)

                Spacer(minLength: 35)

                // Welcome Content
                VStack(spacing: 0) {
                    Image("plant")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: min(geometry.size.width * 0.62, 250),
                            height: min(geometry.size.width * 0.62, 250)
                        )

                    Text("Start your plant journey!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 28)

                    Text("Now all your plants will be in one place and\nwe will help you take care of them :) 🪴")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                }

                Spacer(minLength: 45)

                // Start Button
                Button(action: onStart) {
                    Text("Set Plant Reminder")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            Color(
                                red: 0.16,
                                green: 0.48,
                                blue: 0.40
                            )
                        )
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 50)

                Spacer(minLength: 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
        }
        .preferredColorScheme(.dark)
    }
}

#Preview("Welcome → Plants") {
    AppRootView(previewMode: true)
}
