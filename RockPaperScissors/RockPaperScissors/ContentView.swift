//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Nick Rice on 02/04/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var rockPaperScissors = ["rock", "paper", "scissors"]
    
    let answerRockPaperScissors = ["rock", "paper", "scissors"]
    
    @State private var playerShouldWin = Bool.random()
    @State private var appChoice = Int.random(in: 0 ..< 3)
    
    @State private var playCount = 1
    
    @State private var gameOver = false
    
    var winOrLoseText: String {
        if playerShouldWin == true {
            return "Win"
        } else {
            return "Lose"
        }
    }
    
    @State private var userScore = 0
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    var body: some View {
        ZStack {
            Color(red: 255 / 255, green: 234 / 255, blue: 0 / 255).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("\(playCount) of 10")
//                        .padding(.top, 50.0)
                        .position(x: 210, y: 23)
                        .foregroundColor(.black)
                    
                    Text("You need to")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 10)
                    
                    ZStack {
                        Color.black
                            .frame(width: 120.0, height: 55.0)
                            .clipShape(Capsule())
                        Text("\(winOrLoseText)")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                    } .padding(.bottom, 32)
                    
                    ForEach(0 ..< 1) { number in
                        Image(self.rockPaperScissors[appChoice])
                            .renderingMode(.original)
                            .padding(.top, 10)
                            .padding(.bottom, 40)
                        
                        VStack {
                            Text("Your score")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 10)
                            
                            Text("\(userScore)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.bottom, 140)
                                .padding(.top, 5)
                        }
                        
//                    Text("The choice is yours...")
//                        .font(.title2)
//                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                        .padding(70)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 34, style: .continuous)
                                .fill(Color(red: 231 / 255, green: 215 / 255, blue: 28 / 255))
                                .frame(width: 380.0, height: 140.0)
                                .position(x: 206, y: 4)
//                                .padding(.top, -35.0)
                                    HStack(spacing: 8) {
                                        ForEach(0 ..< 3) { number in
                                            Button(action: {
                                                self.playerChoice(number)
                                                    nextRound()
                                            }) {
                                                Image(self.answerRockPaperScissors[number])
                                                    .resizable()
                                                    .frame(width: 120, height: 120)
                                                
                                            }
                                        }
                                    }
                                    .position(x: 205 , y: 8)
//                                    .padding(.top, 50.0)
                                }
                Spacer()
                    
                }
            }
        }
    }
        .alert(isPresented: $gameOver) {
            Alert(title: Text("Game over!"), message: Text("Your final score was \(userScore)/10"), dismissButton: .default(Text("Play again")) {
                resetGame()
            })
        }
}
    
    func nextRound() {
        if playCount == 10 {
            gameOver = true
        } else {
            playCount += 1
            appChoice = Int.random(in: 0 ..< 3)
            playerShouldWin = Bool.random()
        }
    }
    
    func resetGame() {
        appChoice = Int.random(in: 0 ..< 3)
        playerShouldWin = Bool.random()
        playCount = 1
        userScore = 0
    }
    
    func playerChoice(_ number: Int) {
        // if player should try and WIN:
        if playerShouldWin == true {
            // all the losing scenarios:
            if number == appChoice {
                print("Lose - items the same")
            } else if number == 2 && appChoice == 0 {
                print("Lose - player chose scissors, app chose rock")
            } else if number == 0 && appChoice == 1 {
                print("Lose - player chose rock, app chose paper")
            } else if number == 1 && appChoice == 2 {
                print("Lose - player chose paper, app chose scissors")
            } else {
                print("Win! Add points")
                userScore += 1
            }
        } else {
            // if the player should try and LOSE:
            if playerShouldWin == false {
                // all the winning scenarios:
                if number == appChoice {
                    print("Win - items the same")
                    userScore += 1
                } else if number == 2 && appChoice == 0 {
                    print("Win - player chose scissors, app chose rock")
                    userScore += 1
                } else if number == 0 && appChoice == 1 {
                    print("Win - player chose rock, app chose paper")
                    userScore += 1
                } else if number == 1 && appChoice == 2 {
                    print("Win - player chose paper, app chose scissors")
                    userScore += 1
                } else {
                    print("Lose! No points")
                }

            }
        }
    }
    
//    func moveTapped(_ number: Int) {
//        if number == correctAnswer {
//            userScore += 1
//            scoreTitle = "Correct"
//            scoreTitle = "Your score is..."
//        } else {
//            userScore -= 1
//            scoreTitle = "Wrong"
//            scoreTitle = "Your score is..."
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
