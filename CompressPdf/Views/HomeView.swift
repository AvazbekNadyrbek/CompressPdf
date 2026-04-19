//
//  HomeView.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {

    @Bindable var viewModel: CompressViewModel
    @State private var isPickerShown = false

    var body: some View {
        ZStack {
            Color(hex: "0A0A0F").ignoresSafeArea()
            backgroundGlow

            VStack(spacing: 0) {
                header
                    .padding(.top, 20)

                Spacer()

                dropZone

                Spacer()

                qualityPicker
                    .padding(.bottom, 24)

                compressButton
                    .padding(.bottom, 8)

                Text("3 free files per day")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.25))
                    .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .fileImporter(
            isPresented: $isPickerShown,
            allowedContentTypes: [.pdf]
        ) { result in
            if case .success(let url) = result {
                viewModel.didSelectFile(url: url)
            }
        }
    }

    // MARK: - Subviews

    private var backgroundGlow: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "6366f1").opacity(0.12))
                .frame(width: 400)
                .blur(radius: 80)
                .offset(x: -60, y: -200)

            Circle()
                .fill(Color(hex: "ec4899").opacity(0.08))
                .frame(width: 300)
                .blur(radius: 60)
                .offset(x: 80, y: 200)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "6366f1"), Color(hex: "ec4899")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                        .overlay {
                            Text("📄")
                                .font(.system(size: 16))
                                .accessibilityHidden(true)
                        }

                    Text("PDF SQUEEZE")
                        .font(.caption)
                        .bold()
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.4))
                }

                // Split into two Text views so the gradient applies directly —
                // avoids the fragile .mask + offset(y:) approach.
                VStack(alignment: .leading, spacing: 2) {
                    Text("Compress PDF")
                        .font(.largeTitle).bold()
                        .foregroundStyle(.white)

                    Text("in seconds")
                        .font(.largeTitle).bold()
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "6366f1"), Color(hex: "ec4899")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
            }
            Spacer()
        }
    }

    private var dropZone: some View {
        Button {
            isPickerShown = true
        } label: {
            VStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 20)
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
                    .frame(width: 68, height: 68)
                    .overlay {
                        Text(viewModel.selectedFileURL == nil ? "📎" : "📄")
                            .font(.system(size: 30))
                            .accessibilityHidden(true)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "6366f1").opacity(0.3), lineWidth: 1)
                    }

                if viewModel.selectedFileURL == nil {
                    Text("Select PDF")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("from Files, iCloud, WhatsApp")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.35))
                } else {
                    Text(viewModel.selectedFileName)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text(ByteCountFormatter.string(
                        fromByteCount: Int64(viewModel.selectedFileSize),
                        countStyle: .file
                    ))
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.35))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .background(Color(hex: "6366f1").opacity(0.04))
            .clipShape(.rect(cornerRadius: 28))
            .overlay {
                RoundedRectangle(cornerRadius: 28)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 1.5, dash: [8])
                    )
                    .foregroundStyle(Color(hex: "6366f1").opacity(0.4))
            }
        }
        .accessibilityLabel(
            viewModel.selectedFileURL == nil
            ? "Select a PDF file"
            : "Selected file: \(viewModel.selectedFileName). Tap to change"
        )
    }

    private var qualityPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("COMPRESSION LEVEL")
                .font(.caption)
                .bold()
                .tracking(1.5)
                .foregroundStyle(.white.opacity(0.4))

            HStack(spacing: 8) {
                ForEach(Quality.allCases, id: \.self) { q in
                    Button {
                        viewModel.selectedQuality = q
                    } label: {
                        VStack(spacing: 6) {
                            Text(q.icon)
                                .font(.title2)
                                .accessibilityHidden(true)
                            Text(q.label)
                                .font(.caption).bold()
                                .foregroundStyle(
                                    viewModel.selectedQuality == q
                                    ? .white
                                    : .white.opacity(0.4)
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            viewModel.selectedQuality == q
                            ? LinearGradient(
                                colors: [
                                    Color(hex: "6366f1").opacity(0.3),
                                    Color(hex: "ec4899").opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [Color.white.opacity(0.04)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(.rect(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    viewModel.selectedQuality == q
                                    ? Color(hex: "6366f1").opacity(0.5)
                                    : Color.white.opacity(0.06),
                                    lineWidth: 1
                                )
                        }
                    }
                    .accessibilityLabel(q.label)
                    .accessibilityAddTraits(viewModel.selectedQuality == q ? [.isSelected] : [])
                }
            }
        }
    }

    private var compressButton: some View {
        Button {
            Task { await viewModel.compress() }
        } label: {
            Text("Compress PDF →")
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
                .clipShape(.rect(cornerRadius: 20))
                .shadow(color: Color(hex: "6366f1").opacity(0.35), radius: 16, y: 8)
        }
        .disabled(viewModel.selectedFileURL == nil)
        .opacity(viewModel.selectedFileURL == nil ? 0.5 : 1)
    }
}
