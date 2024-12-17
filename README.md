# LiveStreamAssignment
Stream Playback and Commenting UI
Use Swift, UIKit, AVFoundation, UICollectionView and UITableView. Storyboard UI design and autolayout is preferred, programmatic UIView creation is acceptable.

1.Create a full screen collection view cell with a video player that loads video from a json file.
  a.Video should automatically play and loop.
  b.Display username, profilePicURL, viewers, and likes.
  c.When a user swipes up or down, the video player and overlaid controls should swipe to the next cell. 
  d.Each cell should display full screen, so that only one player is visible at a time.
2.After a video loads, display mock comments in a transparent table view that scrolls new content into view every 2 seconds.
  a.Each comment should display the username, profilePictureURL, and comment.
  b.The comments scroll should have a transparent background with white text and gray text for the user’s name.
3.Allow tapping the comment text field so that the keyboard comes up and pushes all the UI up.
4.After a comment is added, put it into the comments scroll and scroll the other comments up with animation.
