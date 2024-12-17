//
//  CommentViewModel.swift
//  LiveStreamAssignment
//
//  Created by Ruchit on 17/12/24.
//

import Foundation

class CommentViewModel {
    
    // MARK: - Properties
    private var comments: [Comment] = []

    var onDataUpdated: (() -> Void)?
    
    // MARK: - Public Methods
    
    /// Fetches comment data from the local JSON file
    func fetchCommentsList() {
        guard let path = Bundle.main.path(forResource: "comments", ofType: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let commentsList = try decoder.decode(CommentList.self, from: data)
            self.comments = commentsList.comments
            // Notify the view about the data update
            self.onDataUpdated?()
            
        } catch {
            print("Error decoding video list: \(error.localizedDescription)")
        }
    }
    
    func numberOfcomments() -> Int {
        return comments.count
    }
    
    func comments(at index: Int) -> Comment {
        return comments[index]
    }
    
    func addComment(_ comment: Comment) {
        comments.append(comment)
    }
}
