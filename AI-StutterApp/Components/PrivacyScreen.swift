//
//  PrivacyPopup.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 29/04/2026.
//

import SwiftUI

struct PrivacyScreen: View {
    @Binding var allowVoiceData: Bool
    
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
                            .frame(width: 25, height: 28)
                        
                        Text(" Privacy Settings")
                            .foregroundColor(Color("Text"))
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    // Keep title in center
                    Color.clear
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal)
                .padding(.top, 10)                .padding()
                
                Spacer()
                
                // Privacy card
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Privacy Preferences")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Text"))
                    
                    Text("""
                Allow us to use your voice recordings to improve our AI.
                
                Your recordings are private and will never be shared or published.

                This is completely optional and will not affect your ability to use the app.
                """)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("Text"))
                    .lineSpacing(4)
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    HStack {
                        Text("Allow voice data usage")
                            .foregroundColor(Color("Text"))
                        
                        Spacer()
                        
                        Toggle("", isOn: $allowVoiceData)
                            .labelsHidden()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("ButtonColor").opacity(0.25))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding()
                .offset(y: -70)
                
                Spacer()
                
                // Continue button
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
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color("ButtonColor"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color.white.opacity(0.2))
                                )
                        )
                        .padding(.horizontal, 40)
                }
                .offset(y: -64)
            }
        }
    }
}
