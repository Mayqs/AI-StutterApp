//
//  PrivacyPopup.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 29/04/2026.
//

import SwiftUI

struct PrivacyScreen: View {
    @State private var allowVoiceData = false
    
    var onAccept: () -> Void
    var onRefuse: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        ZStack {
            
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Top bar
                HStack {
                    
                    // Back button
                    Button(action: {
                        onBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    // Center text
                    HStack(spacing: 8) {
                        Image("Shield")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Privacy Settings")
                            .foregroundColor(Color("Text"))
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    // Keep title in center
                    Color.clear
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal)
                .padding(.top, 10)                .padding()
                
                Spacer()
                
                // Privay card
                VStack(spacing: 20) {
                    
                    Text("We use your audio data to improve stuttering detection.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("Text"))
                        .padding()
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    HStack {
                        Text("Allow voice data usage")
                            .foregroundColor(Color("Text"))
                        
                        Spacer()
                        
                        Toggle("", isOn: $allowVoiceData)
                            .labelsHidden()
                    }
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("ButtonColor").opacity(0.25))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding()
                
                Spacer()
                
                // Conitinue button
                Button(action: {
                    if allowVoiceData {
                        onAccept()
                    } else {
                        onRefuse()
                    }
                }) {
                    Text("Continue")
                        .foregroundColor(Color("Text"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("ButtonColor"))
                        .cornerRadius(22)
                        .padding(.horizontal, 40)
                }
            }
        }
    }
}
