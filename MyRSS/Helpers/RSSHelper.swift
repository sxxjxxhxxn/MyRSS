//
//  RSSHelper.swift
//  MyRSS
//
//  Created by 서재훈 on 2020/03/19.
//  Copyright © 2020 서재훈. All rights reserved.
//

import Foundation

class RSSHelper: NSObject, XMLParserDelegate {
    
    private var rssItems: [RSS] = []
    private var tempElement = ""
    private var completionHandler: (([RSS]) -> Void)?
    
    private var tempTitle: String = "" {
        didSet {
            tempTitle = tempTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var tempLink: String = "" {
        didSet {
            tempLink = tempLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parseFeed(url: String, completionHandler: (([RSS]) -> Void)?){
        self.completionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            ///parse data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        tempElement = elementName
        
        if tempElement == "item" {
            tempTitle = ""
            tempLink = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch tempElement {
        case "title":
            tempTitle += string
        case "link":
            tempLink += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item"{
            let rssItem = RSS(title: tempTitle, link: URL(string: tempLink)!)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}
