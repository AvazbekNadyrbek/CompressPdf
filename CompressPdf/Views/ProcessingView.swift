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
                
                // Анимированная иконка
                animatedIcon
                
                // Текст
                VStack(spacing: 8) {
                    Text("Сжимаем...")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("\(fileName) · \(ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file))")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.35))
                }
                
                // Прогресс бар
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
    
    private var animatedIcon: some View {
        ZStack {
            // Внешнее кольцо
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
            
            // Иконка
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
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color(hex: "6366f1").opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    Text("🗜️")
                        .font(.system(size: 48))
                )
        }
        .scaleEffect(1.0)
        .animation(
            .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
            value: progress
        )
    }
    
    private var progressBar: some View {
        VStack(spacing: 8) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Фон
                    RoundedRectangle(cornerRadius: 999)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 6)
                    
                    // Прогресс
                    RoundedRectangle(cornerRadius: 999)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "6366f1"), Color(hex: "ec4899")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progress, height: 6)
                        .animation(.easeInOut(duration: 0.2), value: progress)
                }
            }
            .frame(height: 6)
            
            HStack {
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.35))
            }
        }
    }
}
