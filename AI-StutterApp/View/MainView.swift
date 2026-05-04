//
//  MainView.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 29/04/2026.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = MainViewModel()
    
    @State private var activeIndex = 0
    @State private var phase: Double = 0
    @State private var timer: Timer?
    
    @State private var recordingTime: Double = 0
    @State private var recordingTimer: Timer?
    
    @AppStorage("hasSeenPrivacy") var hasSeenPrivacy = false
    @AppStorage("allowVoiceData") var allowVoiceData = false
    
    @State private var screen: ScreenState = .initial
    
    enum ScreenState {
        case initial
        case privacy
        case main
        case result
    }
    
    var body: some View {
        ZStack {
            
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            // Back button
            if screen == .main || screen == .privacy {
                VStack {
                    HStack {
                        
                        Button(action: {
                            screen = .initial
                            vm.isRecording = false
                            stopAnimation()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            
            // Screens
            switch screen {
                
            case .initial:
                initialView
                
            case .privacy:
                PrivacyScreen(
                    allowVoiceData: $allowVoiceData,
                    onAccept: {
                        vm.acceptPrivacy()
                        hasSeenPrivacy = true
                        screen = .main
                    },
                    onRefuse: {
                        vm.refusePrivacy()
                        hasSeenPrivacy = true
                        screen = .main
                    },
                    onBack: {
                        screen = .initial
                    }
                )
                
            case .main:
                mainView
                
            case .result:
                resultView
            }
        }
    }
    
    // Initial screen
    var initialView: some View {
        VStack(spacing: 35) {
            
            // Shield button
            HStack {
                Spacer()
                
                Button(action: {
                    screen = .privacy
                }) {
                    Image("Shield")
                        .resizable()
                        .frame(width: 25, height: 28)
                        .opacity(0.8)
                }
            }
            .padding(.horizontal)
            
            Text("Welcome To Bayan!")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color("Text"))
                .offset(y: -20)
            
            Text("AI-Powered Stuttering Detection App")
                .font(.subheadline)
                .foregroundColor(Color("Text"))
                .offset(y: -40)
            
            Image("Wave")
                .offset(y: -50)
            
            Image("Microphone")
                .resizable()
                .frame(width: 180, height: 250)
                .offset(y: -50)
            
            Button(action: {
                if hasSeenPrivacy {
                    screen = .main  
                } else {
                    screen = .privacy
                }
            }) {
                Text("Start Recording")
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
            .offset(y: -10)
        }
    }
    
    // Main screen
    var mainView: some View {
        VStack(spacing: 8) {
            
            VStack {
                if vm.isRecording {
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                        
                        Text("Recording...")
                            .foregroundColor(Color("Text"))
                            .font(.title)
                    }
                    
                    Text(String(format: "%05.2f", recordingTime))
                        .foregroundColor(Color("Text"))
                        .monospacedDigit()
                    
                } else {
                    Text("Start Recording")
                        .foregroundColor(Color("Text"))
                        .font(.title)
                }
            }
            .frame(height: 80)
            .offset(y: -60)
            
            ZStack {
                Image("Ellipse1")
                    .resizable()
                    .frame(width: 220, height: 220)
                    .opacity(0.3 + 0.7 * smoothPulse(offset: 0.66))
                
                Image("Ellipse2")
                    .resizable()
                    .frame(width: 260, height: 260)
                    .opacity(0.3 + 0.7 * smoothPulse(offset: 0.33))
                
                Image("Ellipse3")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .opacity(0.3 + 0.7 * smoothPulse(offset: 0.0))
                
                Button(action: {
                    if vm.isRecording {
                        stopRecording()
                    } else {
                        vm.startRecording()
                        startRecordingTimer()
                        startSmoothAnimation()
                    }
                }) {
                    Image("Microphone")
                        .resizable()
                        .frame(width: 120, height: 150)
                }
            }
        }
    }
    
    // Result Screen
    var resultView: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            // Title
            Text("Speech Analysis Result")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color("Text"))
            
            // Card
            VStack(alignment: .leading, spacing: 20) {
                
                Text("""
                The analysis detected patterns associated with:
                
                • Prolongation  
                • Sound Repetition  
                • Word Repetition  
                • Block  
                • Interjection
                """)
                .foregroundColor(Color("Text"))
                .lineSpacing(4)
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                Text("Prediction Confidence: 87%")
                    .foregroundColor(Color("Text"))
                    .fontWeight(.medium)
                
                Text("""
                This result is generated by an AI model and is not a medical diagnosis. 
                
                If you have concerns about speech patterns, it is recommended to consult a qualified speech-language professional.
                """)
                .foregroundColor(Color("Text"))
                .font(.footnote)
                .lineSpacing(4)
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
            
            Spacer()
            
            // Done button
            Button(action: {
                screen = .initial
            }) {
                Text("Done")
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
            
            Spacer()
        }
    }
    
    // Animation
    func smoothPulse(offset: Double) -> Double {
        guard vm.isRecording else { return 0 }
        
        let progress = (phase + offset).truncatingRemainder(dividingBy: 1)
        return progress < 0.5 ? progress * 2 : (1 - progress) * 2
    }
    
    func startSmoothAnimation() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            if !vm.isRecording {
                stopAnimation()
                return
            }
            
            phase += 0.01
        }
    }
    
    func stopAnimation() {
        timer?.invalidate()
        timer = nil
        phase = 0
    }
    
    // Timer
    func startRecordingTimer() {
        recordingTime = 0
        recordingTimer?.invalidate()
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            recordingTime += 0.01
            
            if recordingTime >= 15 {
                stopRecording()
            }
        }
    }
    
    func stopRecording() {
        vm.isRecording = false
        
        recordingTimer?.invalidate()
        recordingTimer = nil
        
        stopAnimation()
        recordingTime = 0
        
        screen = .result
    }
}

#Preview {
    MainView()
}
