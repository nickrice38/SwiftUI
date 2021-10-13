//
//  ContentView.swift
//  WordScramble
//
//  Created by Nick Rice on 09/04/2021.
//

import SwiftUI

struct ContentView: View {
    

    @State private var usedWords = ["wordfinder", "dethroned", "defined", "denoted", "drifted", "retired", "defend", "defied", "denied", "dented", "edited", "reword", "ended", "defer", "didnt", "noted", "intro", "other", "order"]
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    // add 10 to the user's score when they get a correct answer
    // add the number of letters they got to their score
    var userScore: Int {
        var tempScore = 0
        
        for word in usedWords {
            tempScore += 10
            tempScore += word.count
        }
        
        return tempScore
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                GeometryReader { fullView in
                    ScrollView(.vertical) {
                        ForEach(0..<self.usedWords.count - 1) { index in
                            GeometryReader { geo in
                                HStack {
                                Image(systemName: "\(self.usedWords[index].count).circle")
                                    .foregroundColor(Color(red: Double(geo.frame(in: .global).minY / fullView.size.height),
                                    green: 0.5,
                                    blue: 0.8))
                                Text("\(self.usedWords[index])")
                                    .font(.title)
                                    .foregroundColor(Color(red: Double(geo.frame(in: .global).minY / fullView.size.height),
                                    green: 0.2,
                                    blue: 0.9))
                                }
                                .frame(width: fullView.size.width, alignment: Alignment.leading)
                                .offset(x: (geo.frame(in: .global).minY - (fullView.size.height) > 8 ? geo.frame(in: .global).minY - (fullView.size.height) : 8),
                                        y: 0)
                                
                            }
                            .frame(height: 40)
                        }
                    }
                }
                
                VStack {
                    Text("Your score")
                    Text("\(userScore)")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(.top, 3)
                }
            }
            .navigationBarTitle(rootWord)
            // add a button in that calls startGame() to reset the game
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("New word") {
                        self.startGame()
                    }
                }
            }
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return}
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not reckognized", message: "You can't just make them up you know!")
            return
        }
        
        guard isRealWord(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }
        
        usedWords.insert(answer, at: 0)
        
        score = 0
        
        for word in usedWords {
            score += 10
            score += word.count * 2
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                print(allWords)
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        if tempWord == word || word.count < 3 { return false }
        
        for letter in tempWord {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
            return false
            }
        }
        return true
    }
    
    func isRealWord(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
