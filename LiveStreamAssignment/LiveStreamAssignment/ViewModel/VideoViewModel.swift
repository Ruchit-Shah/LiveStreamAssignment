//
//  VideoViewModel.swift
//  LiveStreamAssignment
//
//  Created by Ruchit on 17/12/24.
//

import Foundation

class VideoViewModel {
    
    // MARK: - Properties
    private var videos: [Video] = []
    
    // Closure to notify the view when data is updated
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Public Methods
    
    /// Fetches video data from the local JSON file
    func fetchVideoList() {
        guard let path = Bundle.main.path(forResource: "videos", ofType: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let videoList = try decoder.decode(VideoList.self, from: data)
            self.videos = videoList.videos
            
            // Notify the view about the data update
            self.onDataUpdated?()
            
        } catch {
            print("Error decoding video list: \(error.localizedDescription)")
        }
    }
    
    /// Returns the total number of videos
    func numberOfVideos() -> Int {
        return videos.count
    }
    
    /// Returns a video object at a given index
    func video(at index: Int) -> Video {
        return videos[index]
    }
}
