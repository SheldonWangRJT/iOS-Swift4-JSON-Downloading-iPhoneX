//
//  ViewController.swift
//  JSONDownloadingSwift4
//
//  Created by Xiaodan Wang on 9/20/17.
//  Copyright © 2017 Xiaodan Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    final let url = URL(string: "http://microblogging.wingnity.com/JSONParsingTutorial/jsonActors")
    private var actors = [Actor]()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
        tableView.tableFooterView = UIView()
    }

    func downloadJson() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            do
            {
                let decoder = JSONDecoder()
                let downloadedActors = try decoder.decode(Actors.self, from: data)
                self.actors = downloadedActors.actors
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("something wrong after downloaded")
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActorCell") as? ActorCell else { return UITableViewCell() }
        
        cell.nameLbl.text = "Name: " + actors[indexPath.row].name
        cell.DOBLbl.text = "DOB: " + actors[indexPath.row].dob
        
        cell.contentView.backgroundColor = UIColor.darkGray
        cell.backgroundColor = UIColor.darkGray
        
        if let imageURL = URL(string: actors[indexPath.row].image) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imgView.image = image
                    }
                }
            }
        }
        return cell
    }
}

