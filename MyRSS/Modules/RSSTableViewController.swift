//
//  RSSTableViewController.swift
//  MyRSS
//
//  Created by 서재훈 on 2020/03/19.
//  Copyright © 2020 서재훈. All rights reserved.
//

import UIKit

class RSSTableViewController: UITableViewController {
    
    private var rssItems : [RSS]?
    var feed = Feed(name: "Google News", link: "https://news.google.com/rss?hl=ko&gl=KR&ceid=KR:ko")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = feed.name
    }
    
    private func fetchData(){
        let feedParser = RSSHelper()
        feedParser.parseFeed(url: (feed.link)) { (rssItems) in
            self.rssItems = rssItems
            
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else { return 0 }
        return rssItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath)
        
        if let item = rssItems?[indexPath.item]{
            
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { fatalError("selection error") }
        if let rssItems = self.rssItems {
//            if let destination = segue.destination as? WebViewController {
//                destination.linkURL = rssItems[selectedIndexPath.row].link
//            }
        }
    }

}