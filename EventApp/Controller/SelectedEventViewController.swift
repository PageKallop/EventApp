//
//  SelectedEventViewController.swift
//  EventApp
//
//  Created by Page Kallop on 6/24/21.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage


class SelectedEventViewController: UIViewController {
    
    var cell = EventTableViewCell()
    
    var eventvc = EventViewController()
    
    var eventData = [EventData]()
    
    var saveEvent : [EventSaved] = []
 
    let db = Firestore.firestore()

    var url : URL?


    override func viewDidLoad() {
        super.viewDidLoad()
   
        view.backgroundColor = .systemBackground
        view.addSubview(likeLabel)
        view.addSubview(image)
        view.addSubview(eventLabel)
        view.addSubview(descLabel)
        view.addSubview(likeButton)
 
        buttonConstraint()
        imageConstraint()
        eventConstraint()
        descConstraint()
        likeButtonConstrain()
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 50, width: view.frame.size.width, height: 40))
        view.addSubview(navBar)

        let navItem = UINavigationItem(title: "SomeTitle")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(goBack))
        navItem.leftBarButtonItem = doneItem

        navBar.setItems([navItem], animated: false)
        
        likeLabel.isHidden = true
        likeButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        

        
    }
    
    @objc func goBack(){
        
        cell.likeLabel.text = "❤️"
        eventvc.tableView.reloadData()
       
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @objc func tapped() {
    
        print("The Button Has Been Pressed")
        save()
        loadSavedData()
  
//        let newArray = self.eventvc.eventModels.filter { i in self.saveEvent.contains{ i.title == $0.title }
//        let newArray = self.saveEvent.filter { i in self.eventvc.eventModels.contains{ i.title == $0.title }
//        }

    }

    func save(){

        likeLabel.isHidden = false
        
        likeLabel.text = "❤️"
        
      
        let storage = Storage.storage()
        
        let storageRef = storage.reference(forURL: "gs://eventapp-7ee0d.appspot.com")
        
        let storageImageRef = storageRef.child("Post")
        
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        let upLoad = (image.image?.jpegData(compressionQuality: 0.5))!
        
        storageImageRef.putData(upLoad, metadata: metaData) { storageMetadata, error in
            if error != nil {
                print(error)
                return
            }
            
            storageImageRef.downloadURL { url, error in
                if let metaImageUrl = url?.absoluteString {
                    
                    if let title = self.eventLabel.text, let decsription = self.descLabel.text {
                        
                        self.db.collection("Post").addDocument(data: ["title" : title, "description" : self.description, "image" : metaImageUrl]) { (error) in
                            if let e = error {
                                print("errir savinv data \(e)")
                            } else {
                                print("data saved")
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    func loadSavedData(){
        
        db.collection("Post").addSnapshotListener { snapshot, error in

            self.saveEvent = []
            
            if let e = error {
                print("Error retrieving data \(e)")
            } else {

                if let newDoc = snapshot?.documents {

                    for doc in newDoc {

                        let data = doc.data()
                        if let descData = data["description"] as? String, let imageData = data["image"] as? String, let titleData = data["title"] as? String {
                            let newSavePost = EventSaved(title: titleData, subtitle: descData, imageURL: imageData)
                            

                            self.saveEvent.append(newSavePost)
              
                        }

                    }

                }
            }
        }

    }
    
    func eventConstraint(){
     
        eventLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        eventLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        eventLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        eventLabel.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -25).isActive = true
    }
    
    func buttonConstraint(){
        
        likeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: eventLabel.trailingAnchor, constant: 20).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -20).isActive = true
    }
    
    
    func imageConstraint(){
     
        image.topAnchor.constraint(equalTo: eventLabel.bottomAnchor, constant: 25).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400).isActive = true
    }
    
    func likeButtonConstrain(){
        
        likeLabel.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        likeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        likeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -300).isActive = true
        likeLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor).isActive = true
    }
    
    
    func descConstraint(){
     
        descLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 30).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    let likeButton : UIButton = {
        let button = UIButton()
        button.setTitle("Like", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let eventLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
//        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
//        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let image : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    

    let likeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
//        label.text = "❤️"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}
