//
//  CompressViewModel.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import SwiftUI
import Observation


@Observable
class CompressViewModel {
    
    // MARK: -State
    
    enum ViewState {
        case idle
        case loading(Double)
        case result(CompressResult)
        case error(String)
    }
    
    var viewState: ViewState = .idle
    var selectedQuality: Quality = .balance
    var selectedFileURL: URL?
    var selectedFileName: String = ""
    var selectedFileSize: Int = 0
    
    
    private let service = PDFCompressService()
    
    // MARK: - Выбрал файл
    func didSelectFile(url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        defer { url.stopAccessingSecurityScopedResource() }
        
        selectedFileURL = url
        selectedFileName = url.lastPathComponent
        
        // Размер файла
        if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path),
           let size = attrs[.size] as? Int {
            selectedFileSize = size
        }
    }
    
    // MARK: - Сжать
    func compress() async {
        guard let url = selectedFileURL else { return }
        
        // Симулируем прогресс пока сервер работает
        await startProgressAnimation()
        
        do {
            let result = try await service.compress(
                pdfURL: url,
                quality: selectedQuality
            )
            await MainActor.run {
                viewState = .result(result)
            }
        } catch {
            await MainActor.run {
                viewState = .error(error.localizedDescription)
            }
        }
    }
    // MARK: - Сброс
    func reset() {
        viewState = .idle
        selectedFileURL = nil
        selectedFileName = ""
        selectedFileSize = 0
    }
    
    // MARK: - Прогресс анимация
    private func startProgressAnimation() async {
        await MainActor.run { viewState = .loading(0.0) }
        
        // Плавно до 85% пока ждём сервер
        for i in stride(from: 0.0, to: 0.85, by: 0.05) {
            try? await Task.sleep(nanoseconds: 150_000_000)
            await MainActor.run {
                viewState = .loading(i)
            }
        }
    }
}
