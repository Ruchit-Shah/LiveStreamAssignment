//
//  VideoListFetch.swift
//  LiveStreamAssignment
//
//  Created by Ruchit on 17/12/24.
//

import Foundation

class VideoListFetch {
    
    func fetchVideoList(complition: @escaping (_ objStudent: Video?, _ isSuccess: Bool) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase  
        do {
            guard let path = Bundle.main.path(forResource: "videos", ofType: "json") else {
                complition(nil, false)
                return
            }
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path)) // No need to convert to string
            let objVideo = try decoder.decode(Video.self, from: data)
            complition(objVideo, true)
        } catch {
            print("Decoding error: \(error.localizedDescription)") // More specific error message
            complition(nil, false)
        }
    }
}
