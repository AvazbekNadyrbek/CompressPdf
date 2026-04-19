//
//  ErrorView.swift
//  CompressPdf
//
//  Created by Авазбек Надырбек уулу on 4/19/26.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        ZStack {
            Color(hex: "0A0A0F").ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("⚠️")
                    .font(.system(size: 60))
                
                Text("Что-то пошло не так")
                    .font(.title2).bold()
                    .foregroundStyle(.white)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.4))
                    .multilineTextAlignment(.center)
                
                Button(action: onRetry) {
                    Text("Попробовать снова")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color(hex: "6366f1"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(32)
        }
    }
}
