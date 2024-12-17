//
//  VideoCollectionViewCell.swift
//  LiveStreamAssignment
//
//  Created by Ruchit on 17/12/24.
//


import UIKit
import AVFoundation

class VideoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let likeButton = UIButton()
    var onLikeTapped: (() -> Void)? // Callback closure
    private var isPlaying = false  // Track play state

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let viewersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTapGesture() // Add tap gesture recognizer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(viewersLabel)
        contentView.addSubview(likesLabel)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        viewersLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),

            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            viewersLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            viewersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            likesLabel.topAnchor.constraint(equalTo: viewersLabel.bottomAnchor, constant: 8),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        // Like Button
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .white
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        tapGesture.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }
    
    func configure(with video: Video) {
        usernameLabel.text = "@\(video.username)"
        viewersLabel.text = "👁️ \(video.viewers)"
        likesLabel.text = "❤️ \(video.likes)"
        
        if let url = URL(string: video.profilePicURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }.resume()
        }
        
        if let videoUrl = URL(string: video.video) {
            player = AVPlayer(url: videoUrl)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = contentView.bounds
            playerLayer?.videoGravity = .resizeAspectFill
            contentView.layer.insertSublayer(playerLayer!, at: 0)
            player?.actionAtItemEnd = .none
            
            NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            
//            print("configure(with video: Video)")
        }
    }
    
    func play() {
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    @objc private func handleSingleTap() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    @objc private func loopVideo() {
        player?.seek(to: .zero)
        player?.play()
//        print("private func loopVideo()")
    }
    
    @objc private func likeButtonTapped() {
        onLikeTapped?()
    }
}
