//
//  CardTimer.swift
//  Flashy Flash Cards
//
//  Created by Simon Matome on 21/07/2024.
//

import Foundation

final class CardTimer: ObservableObject {
    /// Track progress, value is between 0 and 1
    @Published var progress: Double = 0.0
    /// Tract the user supplied duration for each flashcard
    @Published var duration: TimeInterval = 60
    /// Track time taken
    @Published var timeTaken: TimeInterval = 0
    
    /// varibales to use to time and hold a reference timeframe
    private var timer: Timer?
    private var startTime: Date?
    private var timerRunning = false
    
    
    
    /// Start timer method
    func startTimer() {
        guard !timerRunning else { return } // we are trying to prevent restarting the timer
        resetTimer()
        startTime = Date()
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateProgress()
        }
    }
    
    /// Pause timer method
    func pauseTimer() {
        guard let startTime = startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        timer?.invalidate()
        let newProgress = CGFloat(elapsed / duration)
        if newProgress >= 1.0 {
            progress = 1.0
        } else {
            progress = newProgress
        }
    }
    
    /// Stop timer method
    func stopTimer() {
        guard timerRunning, timeTaken == 0 else { return } // Prevent stopping more than once
        if let startTime = startTime {
            timeTaken = Date().timeIntervalSince(startTime)
        }
        timer?.invalidate()
        timerRunning = false
    }
    
    /// Reset timer method
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        progress = 0.0
        timeTaken = 0
    }
    
    
    /// upgrade progress method
    private func updateProgress() {
        guard let startTime = startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let newProgress = CGFloat(elapsed/duration)
        if newProgress >= 1.0 {
            progress = 1.0
            timer?.invalidate()
        } else {
            progress = newProgress
        }
    }
}
