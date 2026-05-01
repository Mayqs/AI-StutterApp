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
    
    @State private var screen: ScreenState = .initial
    
    enum ScreenState {
        case initial
        case privacy
        case main
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
                            if screen == .privacy {
                                screen = .initial
                            } else {
                                screen = .initial
                                vm.isRecording = false
                                stopAnimation()
                            }
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
                    onAccept: {
                        vm.acceptPrivacy()
                        screen = .main
                    },
                    onRefuse: {
                        vm.refusePrivacy()
                        screen = .main
                    },
                    onBack: {
                        screen = .initial
                    }
                )
                
            case .main:
                mainView
            }
        }
    }
    
    // Initial screen
    var initialView: some View {
        VStack(spacing: 50) {
            
            Text("Welcome!")
                .font(.title)
                .foregroundColor(Color("Text"))
            
            Text("Stuttering Detection")
                .font(.title)
                .foregroundColor(Color("Text"))
            
            Image("Wave")
            
            Image("Microphone")
                .resizable()
                .frame(width: 180, height: 250)
            
            Button(action: {
                screen = .privacy
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
        }
    }
    
    // Main screen
    var mainView: some View {
        VStack(spacing: 8) {
            
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
                    vm.startRecording()
                    startRecordingTimer()
                    startSmoothAnimation()
                }) {
                    Image("Microphone")
                        .resizable()
                        .frame(width: 120, height: 150)
                }
            }
        }
    }
    
    // Mic animation
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
    
    // Mic timer
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
    }
}
        
    #Preview {
        MainView()
    }
