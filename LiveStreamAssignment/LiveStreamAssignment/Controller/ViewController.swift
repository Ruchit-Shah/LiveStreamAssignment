//
//  ViewController.swift
//  LiveStreamAssignment
//
//  Created by Ruchit on 17/12/24.
//

import UIKit
import AVFoundation
import Lottie
import Kingfisher

class ViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var commentTableView: UITableView!
    private var commentInputField: UITextField!
    private let viewModel = VideoViewModel()
    private let commentViewModel = CommentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupCommentTableView()
        setupCommentInputField()
        setupBindings()
        setupBindingsComments()
        setupKeyboardObservers()
        viewModel.fetchVideoList()
        commentViewModel.fetchCommentsList()
        
        setupDoubleTapGesture()
    }
    
 
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCollectionViewCell")
        collectionView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCommentTableView() {
        commentTableView = UITableView()
        commentTableView.backgroundColor = .clear
        commentTableView.separatorStyle = .none
        commentTableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(commentTableView)
        
        NSLayoutConstraint.activate([
            commentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            commentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180),
            commentTableView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupCommentInputField() {
        
        commentInputField = UITextField()
        
        commentInputField.placeholder = "  Comment"
        
        let placeholderColor = UIColor.white // Change to your desired color
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor
        ]
        commentInputField.attributedPlaceholder = NSAttributedString(string: commentInputField.placeholder ?? "", attributes: attributes)
        
        commentInputField.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.2)
        commentInputField.layer.cornerRadius = 20
        commentInputField.borderStyle = .none
        commentInputField.delegate = self
        commentInputField.returnKeyType = .send
        commentInputField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(commentInputField)
        
        let emojiButton = UIButton(type: .system)
        emojiButton.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        emojiButton.tintColor = .black
        emojiButton.translatesAutoresizingMaskIntoConstraints = false
        commentInputField.addSubview(emojiButton)
        
        
        
        NSLayoutConstraint.activate([
            commentInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -160),
            commentInputField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            commentInputField.heightAnchor.constraint(equalToConstant: 40),
            
            emojiButton.trailingAnchor.constraint(equalTo: commentInputField.trailingAnchor, constant: -12),
            emojiButton.centerYAnchor.constraint(equalTo: commentInputField.centerYAnchor),
            
        ])
        
        // Rose Button
        let roseStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.spacing = 2
            return stack
        }()
        
        let roseIcon: UIImageView = {
            let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
            imageView.tintColor = .red
            return imageView
        }()
        
        let roseLabel: UILabel = {
            let label = UILabel()
            label.text = "Rose"
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .white
            return label
        }()
        
        // Gift Button
        let giftStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.spacing = 2
            return stack
        }()
        
        let giftIcon: UIImageView = {
            let imageView = UIImageView(image: UIImage(systemName: "gift.fill"))
            imageView.tintColor = .orange
            return imageView
        }()
        
        let giftLabel: UILabel = {
            let label = UILabel()
            label.text = "Gift"
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .white
            return label
        }()
        
        // Share Button
        let shareStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .center
            stack.spacing = 4
            return stack
        }()
        
        let shareIcon: UIImageView = {
            let imageView = UIImageView(image: UIImage(systemName: "arrowshape.turn.up.right.fill"))
            imageView.tintColor = .white
            return imageView
        }()
        
        let shareCountLabel: UILabel = {
            let label = UILabel()
            label.text = "2"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .white
            return label
        }()
        // Rose Stack
        roseStack.addArrangedSubview(roseIcon)
        roseStack.addArrangedSubview(roseLabel)
        
        // Gift Stack
        giftStack.addArrangedSubview(giftIcon)
        giftStack.addArrangedSubview(giftLabel)
        
        // Share Stack
        shareStack.addArrangedSubview(shareIcon)
        shareStack.addArrangedSubview(shareCountLabel)
        
        // Icons: Rose, Gift, Share
        let iconStackView = UIStackView(arrangedSubviews: [roseStack, giftStack, shareStack])
        iconStackView.axis = .horizontal
        iconStackView.spacing = 20
        iconStackView.alignment = .center
        view.addSubview(iconStackView)
        
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        iconStackView.leadingAnchor.constraint(equalTo: commentInputField.trailingAnchor, constant: 10).isActive = true
        iconStackView.centerYAnchor.constraint(equalTo: commentInputField.centerYAnchor).isActive = true
        
    }
    
    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupBindingsComments() {
        commentViewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.commentTableView.reloadData()
            }
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: 0.3) {
            self.commentInputField.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 10)
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.commentInputField.transform = .identity
        }
    }
    
    private func setupDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc private func handleDoubleTap() {
        showHeartAnimation()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfVideos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        let video = viewModel.video(at: indexPath.row)
        cell.configure(with: video)
        cell.onLikeTapped = { [weak self] in
            self?.showHeartAnimation()
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        collectionView.visibleCells.forEach { ($0 as? VideoCollectionViewCell)?.play() }
        pauseAllVideos()
        playVisibleVideo()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pauseAllVideos()
    }
    
    private func playVisibleVideo() {
        for cell in collectionView.visibleCells {
            if let videoCell = cell as? VideoCollectionViewCell {
                videoCell.play()
            }
        }
    }
    
    private func pauseAllVideos() {
        for cell in collectionView.visibleCells {
            if let videoCell = cell as? VideoCollectionViewCell {
                videoCell.pause()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentViewModel.numberOfcomments()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        let comment = commentViewModel.comments(at: indexPath.row)
        cell.configure(with: comment)
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        
        // Create a new comment
        let newComment = Comment(id: commentViewModel.numberOfcomments() + 1, username: "You", picURL: "", comment: text)
        commentViewModel.addComment(newComment)
        
        // Reload the comment table view
        commentTableView.reloadData()
        
        // Clear and hide the text field
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController {
    func showHeartAnimation() {
        let animationView = LottieAnimationView(name: "heart")
        let animationWidth: CGFloat = 200
        let animationHeight: CGFloat = 200
        
        let xPosition = self.collectionView.bounds.width - animationWidth - 16
        let yPosition = self.collectionView.bounds.height - animationHeight - 46
        
        animationView.frame = CGRect(x: xPosition, y: yPosition, width: animationWidth, height: animationHeight)
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFill
        view.addSubview(animationView)
        
        animationView.play { _ in
            animationView.removeFromSuperview()
        }
    }
}
