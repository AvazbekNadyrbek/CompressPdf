//
//  PDFCompressService.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import Foundation

enum CompressError: LocalizedError {

    case invalidFile
    case serverError(String)
    case networkError

    var errorDescription: String? {
        switch self {
        case .invalidFile:
            return "Файл повреждён или не является PDF"
        case .serverError(let msg):
            return "Ошибка сервера: \(msg)"
        case .networkError:
            return "Нет соединения с интернетом"
        }
    }
}

// Value type so it is implicitly Sendable and nonisolated
struct PDFCompressService {

    private let baseURL = "http://localhost:8080"

    // @concurrent offloads this to the cooperative pool so the main actor is never blocked
    @concurrent
    func compress(pdfData: Data, quality: Quality) async throws -> CompressResult {
        let originalSize = pdfData.count

        let url = URL(string: "\(baseURL)/api/pdf/compress")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60

        let boundary = UUID().uuidString
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"doc.pdf\"\r\n")
        body.append("Content-Type: application/pdf\r\n\r\n")
        body.append(pdfData)
        body.append("\r\n")
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"quality\"\r\n\r\n")
        body.append(quality.rawValue)
        body.append("\r\n--\(boundary)--\r\n")

        request.httpBody = body

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw CompressError.networkError
        }

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw CompressError.serverError("Статус \((response as? HTTPURLResponse)?.statusCode ?? 0)")
        }

        return CompressResult(
            originalSize: originalSize,
            compressedSize: data.count,
            compressedData: data
        )
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
