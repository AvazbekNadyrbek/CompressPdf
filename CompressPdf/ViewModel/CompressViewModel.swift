//
//  CompressViewModel.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
class CompressViewModel {

    // MARK: - State

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

    private var selectedFileData: Data?
    private let service = PDFCompressService()

    // MARK: - Выбрал файл

    func didSelectFile(url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        defer { url.stopAccessingSecurityScopedResource() }

        selectedFileURL = url
        selectedFileName = url.lastPathComponent

        if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path),
           let size = attrs[.size] as? Int {
            selectedFileSize = size
        }

        // Read while the security scope is still open — it closes on defer above
        selectedFileData = try? Data(contentsOf: url)
    }

    // MARK: - Сжать

    func compress() async {
        guard let data = selectedFileData else {
            viewState = .error(CompressError.invalidFile.localizedDescription)
            return
        }
        viewState = .loading(0.0)

        // Start network call and progress animation concurrently
        async let networkResult = service.compress(pdfData: data, quality: selectedQuality)

        for progress in stride(from: 0.05, through: 0.85, by: 0.05) {
            do {
                try await Task.sleep(for: .milliseconds(150))
            } catch {
                break
            }
            guard case .loading = viewState else { break }
            viewState = .loading(progress)
        }

        do {
            viewState = .result(try await networkResult)
        } catch is CancellationError {
            viewState = .idle
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    // MARK: - Сброс

    func reset() {
        viewState = .idle
        selectedFileURL = nil
        selectedFileName = ""
        selectedFileSize = 0
        selectedFileData = nil
    }
}
