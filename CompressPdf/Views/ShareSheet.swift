//
//  ShareSheet.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let data: Data
    let fileName: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        let items: [Any]
        if (try? data.write(to: tempURL)) != nil {
            items = [tempURL]
        } else {
            items = [data]
        }

        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
