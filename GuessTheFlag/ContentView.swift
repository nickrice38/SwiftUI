//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nick Rice on 26/03/2021.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 10 )
    }
}

extension View {
    func buttonStyle() -> some View {
        self.modifier(ButtonStyle())
    }
}

struct ContentView: View {
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var userScore = 0
    @State private var scoreMessage = ""
    
    @State private var flagAngle = [0.0, 0.0, 0.0]
    @State private var flagOpacity = [1.0, 1.0, 1.0]
    @State private var flagBlur: [CGFloat] = [0, 0, 0]
    @State private var greenOutline: [CGFloat] = [0, 0, 0]
    @State private var redOutline: [CGFloat] = [0, 0, 0]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text ("Tap the flag of")
                        .foregroundColor(.white)
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .buttonStyle()
                        }
                    .opacity(self.flagOpacity[number])
                    .blur(radius: self.flagBlur[number])
                    .overlay(Capsule().stroke(Color.green, lineWidth: self.greenOutline[number]))
                    .overlay(Capsule().stroke(Color.red, lineWidth: self.redOutline[number]))
                    .rotation3DEffect(.degrees(self.flagAngle[number]), axis: (x: 0, y: 1, z: 0))
                    .animation(.default)
                    .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                    
                    }
                
                    Text("Your current score is")
                        .foregroundColor(.white)
                        .fontWeight(.regular)
                        .padding(.top, 10.0)
                
                    Text("\(userScore)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding(.top, -10.0)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func correctAnimation() {
        for flag in 0...2 {
            if flag == correctAnswer {
                flagAngle[flag] = 360.0
                greenOutline[flag] = 8
            } else {
                redOutline[flag] = 8
                flagOpacity[flag] = 0.25
            }
        }
    }
    
    func wrongAnimation() {
        for flag in 0...2 {
            if flag != correctAnswer {
                flagBlur[flag] = 3
                redOutline[flag] = 8
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            userScore += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(userScore)"
            correctAnimation()
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "That is the flag of \(countries[number])"
            wrongAnimation()
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        flagAngle = [0.0, 0.0, 0.0]
        flagOpacity = [1.0, 1.0, 1.0]
        flagBlur = [0, 0, 0]
        greenOutline = [0, 0, 0]
        redOutline = [0, 0, 0]
    }
}
// re-shuffles the questions after user has answered


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
