//
//  AddBookView.swift
//  Bookworm
//
//  Created by Nick Rice on 15/07/2021.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var genreSelected: Bool {
        
        // Challenge 1
        let title = self.title.trimmingCharacters(in: .whitespaces)
        let author = self.author.trimmingCharacters(in: .whitespaces)
        let genre = self.genre.trimmingCharacters(in: .whitespaces)
        let review = self.review.trimmingCharacters(in: .whitespaces)
        
        if title.isEmpty || author.isEmpty || genre.isEmpty || review.isEmpty {
            return false
        }
        
        return true
    }
    

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author", text: $author)

                    Picker("Select a genre...", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    RatingView(rating: $rating)

                    TextField("Write a review", text: $review)
                }

                Section {
                    Button("Save") {
                        let newBook = Book(context: self.moc)
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review
                        newBook.date = Date()

                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()

                    }
                }
                .disabled(genreSelected == false)
            }
            .navigationBarTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
