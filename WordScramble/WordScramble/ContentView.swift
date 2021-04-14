//
//  ContentView.swift
//  WordScramble
//
//  Created by Nick Rice on 09/04/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
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
                
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
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
        
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }
        
        // this is where we call the isAllowed function
        guard isAllowed(word: answer) else {
            wordError(title: "Word not allowed", message: "You can't use a word that is less than three letters. You also certainly can't use the startign word!")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
        
    }
    
    func startGame() {
        newWord = ""
        usedWords.removeAll(keepingCapacity: true)
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    // disallow answers thar are shorter than three letters or the same as the start word
    func isAllowed(word: String) -> Bool {
        if word.count < 3 || rootWord.lowercased() == word {
            return false
        }
        
        return true
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
