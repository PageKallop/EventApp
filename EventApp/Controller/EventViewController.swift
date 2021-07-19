//
//  ViewController.swift
//  EventApp
//
//  Created by Page Kallop on 6/23/21.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage


class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let db = Firestore.firestore()
    
    var eventModels = [EventModel]()
    
    var newSavePost : [EventSaved] = []

    let searchVC = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(tableView)
        tableViewConstraints()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        view.backgroundColor = .systemBackground
        
        tableView.rowHeight = 150
        
        navigationItem.title = "Events Page"
        
        navigationController?.navigationBar.prefersLargeTitles = true
    
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "cell")

        getEvents()
        
        createSearchBar()

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getEvents()
        
        tableView.reloadData()
    }
    
    
    func getEvents() {
        
        EventManager.shared.getEvents { [weak self] result in
            switch result {
            case .success(let performers):

                    self?.eventModels = performers.compactMap({ EventModel(title: $0.name, subtitle: $0.type,
                                                                           imageURL: URL(string: $0.image )!)
                })
        
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        db.collection("Post").addSnapshotListener { [self] snapshot, error in
           
            self.newSavePost = []
      
            if let e = error {
                print("Error retrieving data \(e)")
            } else {
               
                
                if let newDoc = snapshot?.documents {
                    
                    for doc in newDoc {
                        
                        let data = doc.data()
                        if let descData = data["description"] as? String, let titleData = data["title"] as? String {
                       
                           let newPost = EventSaved(title: titleData, subtitle: descData)
 
                            self.newSavePost.append(newPost)
                            print("this is the new array that was created \(newSavePost)")
                            }
      
                        }
   
                    }
                    
        
                }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
          }
        
    }
    
    func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    let tableView : UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func tableViewConstraints(){
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventTableViewCell
        
        cell.configureCell(with: eventModels[indexPath.row])
    
        cell.likeLabel.isHidden = true 
        for titles in newSavePost {

            if eventModels[indexPath.row].title == titles.title {
                print("These are the titles you are looking for \(titles.title)")
                cell.likeLabel.isHidden = false
            } else {
            
                    print("not this cell\(newSavePost)")
                
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return eventModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let event = eventModels[indexPath.row]
        let selectedVC = SelectedEventViewController()
        selectedVC.modalPresentationStyle = .fullScreen
        present(selectedVC, animated: true, completion: nil)
        
        selectedVC.eventLabel.text = event.title
        selectedVC.descLabel.text = event.subtitle
        
        if let data = event.imageData {
            selectedVC.image.image = UIImage(data: data)
        }
        else if let url = event.imageURL {
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    selectedVC.url = url

                    selectedVC.image.image = UIImage(data: data)
                }
            }
            .resume()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        let search = text.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "%20")
        
        EventManager.shared.search(with: search){ [weak self] result in
            switch result {
            case .success(let performers):

            
                self?.eventModels = performers.compactMap({ EventModel(title: $0.name, subtitle: $0.type,
                                                                       imageURL: URL(string: $0.image )!)
                    
                })
                DispatchQueue.main.async {
                   
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

