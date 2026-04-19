//
//  CompressResult.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import Foundation

struct CompressResult {
    
    let originalSize: Int
    let compressedSize: Int
    let compressedData: Data
    
    // Процент сжатия считается автоматический
    
    var savedPercent: Int {
        Int((1 - Double(compressedSize) / Double(originalSize)) * 100)
    }
    
    // Читаемый размер
    var originalSizeString: String {
        ByteCountFormatter.string(
            fromByteCount: Int64(originalSize),
            countStyle: .file
        )
    }
    
    var compressedSizeString: String {
        ByteCountFormatter.string(
            fromByteCount: Int64(compressedSize),
            countStyle: .file
        )
    }
    
}
