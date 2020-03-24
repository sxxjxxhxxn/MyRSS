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
        let id = indexPath.item
        
        if let item = self.rssItems?[id] {
            cell.rssTitleLabel.text = item.title
            cell.link = item.link
            
            if let description = item.description {
                cell.rssDescriptionLabel.text = description
                cell.keywords = description.keyword()
                DispatchQueue.global().async {
                    if let imageUrlString = item.imageLink {
                        if let imageUrl = URL(string: imageUrlString) {
                            if let imageData = try? Data(contentsOf: imageUrl) {
                                DispatchQueue.main.async {
                                    cell.rssImage = UIImage(data: imageData)
                                }
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.global().async {
                    var description: String?
                    var imageLink: String?
                    do {
                        if let head = try HTML(url: item.link, encoding: .utf8).head {
                            for metadata in head.css("meta[property='og:description']") {
                                description = metadata["content"]
                                DispatchQueue.main.async {
                                    cell.rssDescriptionLabel.text = description
                                    cell.keywords = description?.keyword()
                                }
                            }
                            for metadata in head.css("meta[property='og:image']") {
                                imageLink = metadata["content"]
                                if let imageUrlString = imageLink {
                                    if let imageUrl = URL(string: imageUrlString) {
                                        if let imageData = try? Data(contentsOf: imageUrl) {
                                            DispatchQueue.main.async {
                                                cell.rssImage = UIImage(data: imageData)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print(error, " at : ", id)
                        DispatchQueue.main.async {
                            cell.rssDescriptionLabel.text = "\(item.link)"
                            cell.keywords = ["...", "...", "..."]
                        }
                    }
                    self.rssItems![id].description = description
                    self.rssItems![id].imageLink = imageLink
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { fatalError("selection error") }
        guard let cell = tableView.cellForRow(at: selectedIndexPath) as? RSSTableViewCell else { fatalError("selected cell's type convertion error") }
        
        if let destination = segue.destination as? RSSWebViewController {
            destination.title = cell.rssTitleLabel.text
            destination.linkURL = cell.link
            destination.keywords = cell.keywords
        }
    }

}
