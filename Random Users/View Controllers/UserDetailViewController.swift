//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Jordan Christensen on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: RandomUser? {
        didSet {
            updateViews()
        }
    }
    var cache: Cache<String, UIImage>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
        guard let cache = cache, let user = user, isViewLoaded else { return }
        
        if let image = cache.fetch(key: "\(user.picture.large)") {
            userImageView.image = image
        } else {
            guard let imageURL = URL(string: user.picture.large) else { return }
            let imageRequest = URLRequest(url: imageURL)
            
            URLSession.shared.dataTask(with: imageRequest) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching image data: \(error)")
                    return
                }
                
                guard let data = data else {
                    NSLog("Error. No data returned from given URL")
                    return
                }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.userImageView.image = image
                        
                    if let image = image {
                        self.cache?.imageDict["\(user.picture.large)"] = image
                    }
                }
            }.resume()
        }
        
        title = "\(user.name.title.capitalized). \(user.name.last.capitalized)"
        nameLabel.text = "\(user.name.title.capitalized). \(user.name.first.capitalized) \(user.name.last.capitalized)"
        phoneNumberLabel.text = "Cell Phone: \(user.cell)\nHome Phone: \(user.phone)"
        emailLabel.text = "\(user.email)"
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
