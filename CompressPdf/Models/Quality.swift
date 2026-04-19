//
//  Quality.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import Foundation

enum Quality: String, CaseIterable {
    
    case max = "low"
    case balance = "medium"
    case high = "high"
    
    var label: String {
        switch self {
        case .max: return "Maximum"
        case .balance: return "Balanced"
        case .high: return "Quality"
        }
    }
    
    var icon: String {
           switch self {
           case .max:     return "🗜️"
           case .balance: return "⚖️"
           case .high:    return "✨"
           }
       }
}
