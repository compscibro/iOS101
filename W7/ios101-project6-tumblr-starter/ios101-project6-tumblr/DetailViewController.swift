//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
//  Created by Mohammed Abdur Rahman on 11/9/25.
//

import UIKit
import NukeExtensions

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if post == nil {
            fatalError("Post must be set")
        }

        if let photo = post.photos.first {
            let url = photo.originalSize.url
            NukeExtensions.loadImage(with: url, into: detailImageView)
        }
        
        captionTextView.text = post.caption.trimHTMLTags()
        captionTextView.isEditable = false
        captionTextView.isSelectable = false
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
