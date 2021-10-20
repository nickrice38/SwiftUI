//
//  RollView.swift
//  DiceRoller
//
//  Created by Nick Rice on 18/10/2021.
//

import SwiftUI

struct RollView: View {
    @State private var phoneWiggle = false
    
    let shakeTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    @ObservedObject var rolls = Rolls.shared
    
    @State private var currentRoll = Roll(firstDice: 1, secondDice: 6)
    @State private var rollInProgress = false
    @State private var animationRollTimes = 10
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(decorative: "background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("Roll total:")
                            .padding(.top, 40)
                            .padding(.bottom, 30)
                            .font(Font.system(size: 24, weight: .light))
                        
                        Text("\(self.currentRoll.firstDice + self.currentRoll.secondDice)")
                            .padding(.top, 40)
                            .padding(.bottom, 30)
                            .font(Font.system(size: 24, weight: .bold))
                    }
                    
                    VStack {
                        Image("Dice\(self.currentRoll.firstDice)")
                            .resizable()
                            .frame(width: 140, height: 140)
                            .padding(.bottom, 15)
                        
                        Image ("Dice\(self.currentRoll.secondDice)")
                            .resizable()
                            .frame(width: 140, height: 140)
                            .padding(.top, 15)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image("phoneShake")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 60)
                            .rotationEffect(.degrees(phoneWiggle ? 4 : 0))
                            .animation(Animation.easeInOut(duration: 0.15).repeatCount(9, autoreverses: true)
                                        .delay(0.5))
                            .onReceive(self.shakeTimer) { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    phoneWiggle.toggle()
                                }
                            }
                        
                        Text("Shake your device to roll the dice!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .onShake {
                                self.rollInProgress = true
                                self.feedback.prepare()
                            }
                            
                            .onReceive(timer) { time in
                                guard self.rollInProgress else { return }
                                
                                if self.animationRollTimes > 0 {
                                    let firstDice = Int.random(in: 1...6)
                                    let secondDice = Int.random(in: 1...6)
                                    
                                    self.feedback.notificationOccurred(.warning)
                                    
                                    withAnimation(.spring()) {
                                        self.currentRoll = Roll(firstDice: firstDice, secondDice: secondDice)
                                    }
                                    
                                    self.animationRollTimes -= 1
                                } else {
                                    self.rollInProgress = false
                                    self.animationRollTimes = 10
                                    self.rolls.add(self.currentRoll)
                                }
                            }
                    }
                    .padding(.vertical, 30)
                    
                }
            }
            .navigationBarTitle("Ready to Roll")
            
        }
    }
    
//    init() {
//        // Use this if NavigationBarTitle is with Large Font
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//    }
    
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

struct RollView_Previews: PreviewProvider {
    static var previews: some View {
        RollView()
    }
}
