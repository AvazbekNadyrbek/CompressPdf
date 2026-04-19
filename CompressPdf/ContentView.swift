//
//  ContentView.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import SwiftUI

struct ContentView: View {

    @State private var viewModel = CompressViewModel()

    var body: some View {
        switch viewModel.viewState {
        case .idle:
            HomeView(viewModel: viewModel)

        case .loading(let progress):
            ProcessingView(
                fileName: viewModel.selectedFileName,
                fileSize: viewModel.selectedFileSize,
                progress: progress
            )

        case .result(let result):
            ResultView(
                result: result,
                onReset: { viewModel.reset() }
            )

        case .error(let message):
            ErrorView(message: message) {
                viewModel.reset()
            }
        }
    }
}

#Preview("Home") {
    ContentView()
}

#Preview("Processing") {
    ProcessingView(
        fileName: "document.pdf",
        fileSize: 15_200_000,
        progress: 0.65
    )
}

#Preview("Result") {
    ResultView(
        result: CompressResult(
            originalSize: 15_200_000,
            compressedSize: 2_800_000,
            compressedData: Data()
        ),
        onReset: {}
    )
}

#Preview("Error") {
    ErrorView(
        message: "Нет соединения с интернетом",
        onRetry: {}
    )
}
