//
//  PostTableViewCell.swift
//  SNApp
//
//  Created by ALEKSANDR GRIGOREV on 09.03.2021.
//

import UIKit
import RealmSwift

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(post: Post) {
        self.authorNameLabel.text = post.author
        self.likesCountLabel.text = "\(post.likes) ❤️"
        self.commentsCountLabel.text  = "Comments: \(post.comments)"
        self.textView.text = post.text
        
        self.avatarImageView.image = nil
        do {
            let realm = try Realm()
            let urlString = post.avatar
            let result = Array(realm.objects(PhotoData.self).filter("url == %@", urlString))
            if result.count > 0, let data = result[0].data {
                self.avatarImageView.image = UIImage(data: data)
                if result.count > 1 {
                    print("More than 1 photo in Realm for url: \(urlString)")
                }
            }
            else if let url = URL(string:urlString),
                    let data = try? Data(contentsOf: url) {
                let photoData = PhotoData()
                photoData.url = urlString
                photoData.data = data
                
                realm.beginWrite()
                realm.add(photoData)
                try realm.commitWrite()
                
                self.avatarImageView.image = UIImage(data: data)
            }
        } catch {
            print(error)
        }
    }
}
