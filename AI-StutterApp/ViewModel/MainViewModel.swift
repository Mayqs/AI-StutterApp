//
//  MainViewModel.swift
//  AI-StutterApp
//
//  Created by May Alqunaytir on 29/04/2026.
//

import SwiftUI
internal import Combine

class MainViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var showPrivacy = false
    @Published var result: String? = nil
    
    func startRecording() {
        isRecording = true
        result = nil
        
        // fake delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isRecording = false
            self.result = "No Stutter Detected"
        }
    }
    
    func acceptPrivacy() {
        showPrivacy = false
    }
    
    func refusePrivacy() {
        showPrivacy = false
    }
}
