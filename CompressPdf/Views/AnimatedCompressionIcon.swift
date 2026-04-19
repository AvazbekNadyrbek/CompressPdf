//
//  AnimatedCompressionIcon.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import SwiftUI

struct AnimatedCompressionIcon: View {

    @State private var isPulsing = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "6366f1"), Color(hex: "ec4899")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(width: 130, height: 130)
                .opacity(0.3)

            RoundedRectangle(cornerRadius: 32)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "6366f1").opacity(0.2),
                            Color(hex: "ec4899").opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 110, height: 110)
                .overlay {
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color(hex: "6366f1").opacity(0.3), lineWidth: 1)
                }
                .overlay {
                    Text("🗜️")
                        .font(.system(size: 48))
                        .accessibilityHidden(true)
                }
        }
        .scaleEffect(isPulsing ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isPulsing)
        .onAppear { isPulsing = true }
        .accessibilityLabel("Сжатие файла")
        .accessibilityAddTraits(.isImage)
    }
}
