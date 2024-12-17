//
//  Comment.swift
//  LiveStreamAssignment
//
//  Created by Ruchit on 17/12/24.
//

import Foundation

struct CommentList: Codable {
    let comments: [Comment]
}

struct Comment: Codable {
    let id: Int
    let username: String
    let picURL: String
    let comment: String
    
//    init(id: Int, username: String, picURL: String, comment: String) {
//            self.id = id
//            self.username = username
//            self.picURL = picURL
//            self.comment = comment
//        }
}
