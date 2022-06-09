//
//  SentMemeTableViewController.swift
//  MemeMeTwo
//
//  Created by Dhruv Shah on 15/08/21.
//

import UIKit

class SentMemeTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    var memes: [MemeMeTwo] {
               return (UIApplication.shared.delegate as! AppDelegate).memes
           }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       tableView?.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appDelegate.memes.count == 0 ? showEmptyView(true) : showEmptyView(false)
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableViewCell", for: indexPath) as! SentMemeTableViewCell
        let meme: MemeMeTwo = appDelegate.memes[indexPath.row]
        cell.cellImageView.image = meme.newImage
        cell.cellTopTextLabel.text = meme.topText
        cell.cellBottomTextLabel.text = meme.bottomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
                detailViewController.memeToShow = memes[(indexPath as NSIndexPath).row]
                navigationController!.pushViewController(detailViewController, animated: true)
       }
    
    func showEmptyView(_ show: Bool) {
        if show{
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "There are no memes, please click 'Add' to create a meme."
            tableView.backgroundView = label
            tableView.separatorStyle = .none
            navigationItem.leftBarButtonItem = nil
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            navigationItem.leftBarButtonItem = editButtonItem
        }
    }
}
