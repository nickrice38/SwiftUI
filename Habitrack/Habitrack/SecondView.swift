//
//  SecondView.swift
//  Habitrack
//
//  Created by Nick Rice on 14/06/2021.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(Color.offWhite)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                            )
                        
                    } else {
                        Circle()
                            .fill(Color.offWhite)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
            )
    }
}

struct SecondView: View {
    @ObservedObject var activities: Activities
    
    var activity: ActivityStruct
    
    @State private var barTitle: String = ""
    @State private var completed: Int = 0
    
    var body: some View {
        ZStack {
            Color.offWhite
 
            VStack {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .opacity(0.5)
                            .frame(width: 335, height: 70)
                            .offset(x: 0, y: 80 + 25)
                        
                        Text("\(activity.description)").font(Font.custom("Rubik-Regular", size: 17))
                            .foregroundColor(.gray)
                            .frame(width: 310, height: 70, alignment: .topLeading)
                            .offset(x: 2, y: 120)
                        
                        ZStack {
                            HStack(spacing: 25) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .opacity(0.5)
                                    .frame(width: 220, height: 90)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .opacity(0.5)
                                    .frame(width: 90, height: 90)
                            }
                            
                            Text("\(activity.name)").font(Font.custom("Rubik-Bold", size: 28))
                                .foregroundColor(.black)
                                .frame(width: 220, height: 70, alignment: .topLeading)
                                .offset(x: -42, y: 19)
                            
                            Text("\(completed)").font(Font.custom("Rubik-Bold", size: 32))
                                .foregroundColor(.black)
                                .frame(width: 90, height: 70, alignment: .center)
                                .offset(x: 122, y: -14)
                            
                            Text("Tracked").font(Font.custom("Rubik-Regular", size: 17))
                                .foregroundColor(.gray)
                                .frame(width: 90, height: 70, alignment: .center)
                                .offset(x: 123, y: 15)
                        }
                    }
                }
                .offset(x: 0, y: -200)
                
                    HStack(spacing: 60) {
                        Button(action: {
                            completed -= 1
                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                            impactMed.impactOccurred()
                        }) {
                            Image("minus")
                        }
                        .buttonStyle(SimpleButtonStyle())
                        
                        Button(action: {
                            completed += 1
                            let impactHev = UIImpactFeedbackGenerator(style: .light)
                            impactHev.impactOccurred()
                        }) {
                            Image("plus")
                        }
                        .buttonStyle(SimpleButtonStyle())
                }
            }
        }
        .onAppear {
            self.barTitle = self.activity.name
            self.completed = self.activity.completed
        }
        .onDisappear {
            if let index = self.activities.items.firstIndex(where: { $0 == self.activity}) {
                self.activities.items.remove(at: index)
                var tempActivity = self.activity
                tempActivity.completed = self.completed
                self.activities.items.insert(tempActivity, at: index)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(activities: Activities(), activity: ActivityStruct(name: "Title", description: "Description"))
    }
}
