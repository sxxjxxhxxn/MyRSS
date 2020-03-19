//
//  RSSTableViewController.swift
//  MyRSS
//
//  Created by 서재훈 on 2020/03/19.
//  Copyright © 2020 서재훈. All rights reserved.
//

import UIKit
import Kanna

class RSSTableViewController: UITableViewController {
    
    private var rssItems: [RSS]?
    var feed = Feed(name: "Google News", link: "https://news.google.com/rss?hl=ko&gl=KR&ceid=KR:ko")
    /// refresh tableView
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refresher
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = feed.name
    }
    
    @objc private func fetchData(){
        let feedParser = RSSHelper()
        feedParser.parseFeed(url: (feed.link)) { (rssItems) in
            self.rssItems = rssItems
            
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
                self.refreshControl?.endRefreshing()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RSSTableViewCell", for: indexPath) as? RSSTableViewCell else { fatalError("cell type convertion error") }
        
        if let item = rssItems?[indexPath.item]{
            cell.rssTitleLabel.text = item.title
            DispatchQueue.global().async {
                do {
                    if let head = try HTML(url: item.link, encoding: .utf8).head {
                        for metadata in head.css("meta[property='og:image']"){
                            if let imageLink = metadata["content"] {
                                let imageUrl = URL(string: imageLink)!
                                if let imageData = try? Data(contentsOf: imageUrl) {
                                    DispatchQueue.main.async {
                                        cell.rssImage = UIImage(data: imageData)
                                    }
                                }
                            }
                        }
                        for metadata in head.css("meta[name='description']"){
                            DispatchQueue.main.async {
                                cell.rssDescriptionLabel.text = metadata["content"]
                            }
                        }
                    }
                } catch {
                    print("can't parse html")
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { fatalError("selection error") }
        if let rssItems = self.rssItems {
            if let destination = segue.destination as? RSSWebViewController {
                let rssItem = rssItems[selectedIndexPath.row]
                destination.title = rssItem.title
                destination.linkURL = rssItem.link
            }
        }
    }

}
