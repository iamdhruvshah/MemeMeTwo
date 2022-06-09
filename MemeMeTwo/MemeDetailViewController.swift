//
//  MemeDetailViewController.swift
//  MemeMeTwo
//
//  Created by Dhruv Shah on 15/08/21.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeToShow: MemeMeTwo!

    @IBOutlet var memeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = memeToShow.newImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
