//
//  UITableViewCell+Extension.swift
//  Real
//
//  Created by 唐紹桓 on 2020/11/26.
//

import UIKit

enum CellId: String {
    
    case post = "PostCell"
    
    case comment = "CommentCell"
    
    case topic = "TopicCell"
    
    case postTitle = "PostTitleCell"
    
    case postContent = "PostContentCell"
    
    case notificationCell = "NotificationCell"
    
    case vote = "VoteCell"
    
    case userMessage = "UserMessageCell"
    
    case receiverMessage = "ReceiverMessageCell"
    
    case driftingBottle = "DriftingBottleCell"
    
    case chatList = "ChatListCell"
}

extension UITableViewCell {
    
    static let emptyCell = UITableViewCell()

}

extension String {
    
    static func cell(identifier: CellId) -> String {
        
        return identifier.rawValue
    }
}
