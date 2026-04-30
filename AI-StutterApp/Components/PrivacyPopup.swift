//
//  PrivacyPopup.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 29/04/2026.
//

import SwiftUI

struct PrivacyPopup: View {
    var onAccept: () -> Void
    var onRefuse: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("We use your audio data to improve stuttering detection. Do you agree?")
                    .multilineTextAlignment(.center)
                
                Button("Allow") {
                    onAccept()
                }
                .foregroundColor(.green)
                
                Button("Refuse") {
                    onRefuse()
                }
                .foregroundColor(.red)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .padding(40)
        }
    }
}
