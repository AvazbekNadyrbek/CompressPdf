//
//  ProcessingView.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import SwiftUI

struct ProcessingView: View {

    let fileName: String
    let fileSize: Int
    let progress: Double

    var body: some View {
        ZStack {
            Color(hex: "0A0A0F").ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                AnimatedCompressionIcon()

                VStack(spacing: 8) {
                    Text("Сжимаем...")
                        .font(.title2).bold()
                        .foregroundStyle(.white)

                    Text("\(fileName) · \(ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file))")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.35))
                }

                progressBar

                Spacer()

                Text("Ghostscript обрабатывает файл на сервере")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.2))
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 32)
        }
    }

    // MARK: - Subviews

    private var progressBar: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 999)
                .fill(Color.white.opacity(0.08))
                .frame(height: 6)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 999)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "6366f1"), Color(hex: "ec4899")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .containerRelativeFrame(.horizontal) { w, _ in w * progress }
                        .frame(height: 6)
                        .animation(.easeInOut(duration: 0.2), value: progress)
                }

            HStack {
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.35))
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Прогресс сжатия \(Int(progress * 100)) процентов")
        .accessibilityValue("\(Int(progress * 100))%")
    }
}
