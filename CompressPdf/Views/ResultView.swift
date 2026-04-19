//
//  ResultView.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import SwiftUI

import SwiftUI

struct ResultView: View {
    
    let result: CompressResult
    let onReset: () -> Void
    
    @State private var isShareShown = false
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F").ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Иконка успеха
                successIcon
                    .padding(.bottom, 24)
                
                // Заголовок
                VStack(spacing: 6) {
                    Text("Готово!")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Файл успешно сжат")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.35))
                }
                .padding(.bottom, 36)
                
                // Карточка статистики
                statsCard
                    .padding(.bottom, 16)
                
                // Приватность
                privacyNote
                    .padding(.bottom, 36)
                
                Spacer()
                
                // Кнопки
                VStack(spacing: 12) {
                    // Сохранить
                    Button {
                        isShareShown = true
                    } label: {
                        Label("Сохранить PDF", systemImage: "square.and.arrow.down")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "6366f1"), Color(hex: "ec4899")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(
                                color: Color(hex: "6366f1").opacity(0.35),
                                radius: 16, y: 8
                            )
                    }
                    
                    // Сжать ещё
                    Button(action: onReset) {
                        Text("Сжать ещё один")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                    }
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .sheet(isPresented: $isShareShown) {
            ShareSheet(data: result.compressedData, fileName: "compressed.pdf")
        }
    }
    
    // MARK: - Subviews
    
    private var successIcon: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(
                LinearGradient(
                    colors: [
                        Color(hex: "22c55e").opacity(0.2),
                        Color(hex: "6366f1").opacity(0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 90, height: 90)
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color(hex: "22c55e").opacity(0.3), lineWidth: 1)
            )
            .overlay(Text("✅").font(.system(size: 40)))
    }
    
    private var statsCard: some View {
        VStack(spacing: 20) {
            // До / Процент / После
            HStack {
                // До
                VStack(spacing: 4) {
                    Text("ДО")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.3))
                    
                    Text(result.originalSizeString)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                // Процент
                VStack(spacing: 4) {
                    Text("-\(result.savedPercent)%")
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "22c55e"), Color(hex: "6366f1")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    Text("сэкономлено")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.25))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(hex: "22c55e").opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "22c55e").opacity(0.2), lineWidth: 1)
                )
                
                Spacer()
                
                // После
                VStack(spacing: 4) {
                    Text("ПОСЛЕ")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.3))
                    
                    Text(result.compressedSizeString)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color(hex: "22c55e"))
                }
            }
            
            // Визуальная полоска
            VStack(alignment: .leading, spacing: 6) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 999)
                            .fill(Color.white.opacity(0.06))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 999)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "22c55e"), Color(hex: "6366f1")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geo.size.width * (1 - Double(result.savedPercent) / 100),
                                height: 8
                            )
                    }
                }
                .frame(height: 8)
                
                Text("Новый размер составляет \(100 - result.savedPercent)% от оригинала")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.2))
            }
        }
        .padding(24)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.07), lineWidth: 1)
        )
    }
    
    private var privacyNote: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock.fill")
                .font(.caption)
                .foregroundStyle(Color(hex: "6366f1"))
            
            Text("Файл удалён с сервера сразу после сжатия")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.35))
            
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(hex: "6366f1").opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "6366f1").opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - ShareSheet
struct ShareSheet: UIViewControllerRepresentable {
    let data: Data
    let fileName: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(fileName)
        try? data.write(to: tempURL)
        
        return UIActivityViewController(
            activityItems: [tempURL],
            applicationActivities: nil
        )
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
