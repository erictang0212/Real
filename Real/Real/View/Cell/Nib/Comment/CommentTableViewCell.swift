//
//  CommentTableViewCell.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/27.
//

import UIKit

class CommentTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var propicImageView: UIImageView!
    
    @IBOutlet weak var randomNameLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    var comment: Comment?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(data: Comment) {
        
        self.comment = data
        
        propicImageView.loadImage(urlString: data.authorImage, placeHolder: #imageLiteral(resourceName: "animal"))
        
        randomNameLabel.text = data.authorName
        
        createdTimeLabel.text = data.createdTime.compareCurrentTime()
        
        contentLabel.text = data.content
        
        likeCountLabel.text = data.likeCount.count == 0 ? .empty: String(data.likeCount.count)
        
        guard let user = userManager.userData else {
            
            print("CommentTableViewCell no user data")
            
            return
        }
        
        likeButton.isSelected = data.likeCount.contains(user.id)
    }
    
    @IBAction func likeComment(_ sender: UIButton) {
        
        guard let user = userManager.userData else {
            
            print(" CommentTableViewCell no user data")
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        
        guard let comment = self.comment else { return }
        
        let collection = firebase.getCollection(name: .comment).document(comment.id)
        
        if comment.likeCount.contains(user.id) {
            
            collection.updateData([
                "likeCount": FIRFieldValue.arrayRemove([user.id])
            ])
            
        } else {
            
            collection.updateData([
                "likeCount": FIRFieldValue.arrayUnion([user.id])
            ])
        }
    }
}
