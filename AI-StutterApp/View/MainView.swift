//
//  MainView.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 29/04/2026.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = MainViewModel()
    @State private var animate = false
    @State private var activeIndex = 0
    @State private var phase: Double = 0
    @State private var timer: Timer?
    @State private var started = false
    @State private var seconds = 0
    @State private var recordingTimer: Timer?
    
    var body: some View {
        ZStack {
            // Background
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            
            // Initial screen
            if !started {
                
                VStack(spacing: 50) {
                        
                        // Title
                        Text("Welcome!")
                            .font(.title)
                            .foregroundColor(Color("Text"))
                            .padding(.top, -70)
                        
                        Text("Stuttering Detection")
                            .font(.title)
                            .foregroundColor(Color("Text"))
                            .padding(.top, -60)
                        
                        Image("Wave")
                            .padding(.top, -60)
                        
                    
                    Image("Microphone")
                        .resizable()
                        .frame(width: 180, height: 250)
                        .padding(.top, 20)
                    
                    Button(action: {
                        vm.showPrivacy = true
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
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .shadow(color: Color.white.opacity(0.2), radius: 2, x: -2, y: -2) // top light
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 3, y: 3) // bottom shadow
                            .padding(.horizontal, 40)
                    }
                }
                
            } else {
                
                // Main screen
                
                VStack(spacing: 8) {
                    
                    if vm.isRecording {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                            
                            Text("Recording...")
                                .foregroundColor(Color("Text"))
                                .font(.title)
                        }
                        
                        Text("\(seconds) sec")
                            .foregroundColor(Color("Text"))
                            .font(.subheadline)
                        
                    } else {
                        Text("Start Recording")
                            .foregroundColor(Color("Text"))
                            .font(.title)
                    }
                }
                .offset(y: -300)
                
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
                        startSmoothAnimation()
                        startRecordingTimer()
                    }) {
                        Image("Microphone")
                            .resizable()
                            .frame(width: 120, height: 150)
                    }
                }
                .offset(y: 0)
            }
            
            // Privacy popup
            if vm.showPrivacy {
                PrivacyPopup(
                    onAccept: {
                        vm.acceptPrivacy()
                        started = true
                    },
                    onRefuse: {
                        vm.refusePrivacy()
                        started = true
                    }
                )
            }        }
    }
    
    func startPulseAnimation() {
        guard vm.isRecording else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
            if !vm.isRecording {
                timer.invalidate()
                return
            }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                activeIndex = (activeIndex + 1) % 3
            }
        }
    }
    
    func smoothPulse(offset: Double) -> Double {
        guard vm.isRecording else { return 0 }
        
        let progress = (phase + offset).truncatingRemainder(dividingBy: 1)
        
        // smooth fade
        return progress < 0.5
            ? progress * 2
            : (1 - progress) * 2
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
        
        withAnimation(.easeOut(duration: 0.3)) {
            phase = 0
        }
    }
    
    func startRecordingTimer() {
        seconds = 0
        recordingTimer?.invalidate()
        
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            seconds += 1
            
            if seconds >= 15 {
                stopRecording()
            }
        }
    }
    
    func stopRecording() {
        vm.isRecording = false
        
        recordingTimer?.invalidate()
        recordingTimer = nil
        
        stopAnimation()
        
        seconds = 0
    }
}

#Preview {
    MainView()
}
