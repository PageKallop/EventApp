//
//  EventTableViewCell.swift
//  EventApp
//
//  Created by Page Kallop on 6/23/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = .secondarySystemBackground
        addSubview(stackView)
        stackConstraint()
        addSubview(image)
        addSubview(likeLabel)

        imageConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        typeLabel.text = nil
        image.image = nil 
    }
    

    func configureCell(with eventModel: EventModel){
        
        titleLabel.text = eventModel.title
        typeLabel.text = eventModel.subtitle
        
        if let data = eventModel.imageData {
            image.image = UIImage(data: data)
        }
        else if let url = eventModel.imageURL {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }
            .resume()
        }
    }
    
    func stackConstraint(){
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(typeLabel)
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -175).isActive = true
    }
    
    func likeLabelConstraint () {
        
        likeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        likeLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 5).isActive = true
        likeLabel.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -5).isActive = true
        likeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    
    func imageConstraint(){
      
        image.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 250).isActive = true
        
    }
    
    let titleLabel : UILabel = {
       let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.numberOfLines = 0 
//        title.backgroundColor = .green
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let typeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
//        label.backgroundColor = .purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let image : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var stackView: UIStackView = {
         let stackView = UIStackView()
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.axis = .vertical
         stackView.backgroundColor = .clear
         stackView.spacing = 15
         stackView.alignment = .fill
         stackView.distribution = .fillProportionally
         return stackView
     }()
    
    let likeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
