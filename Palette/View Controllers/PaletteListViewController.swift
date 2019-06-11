//
//  PaletteListViewController.swift
//  Palette
//
//  Created by Haley Jones on 6/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PaletteListViewController: UIViewController {

    //Source of Truth
    var photos: [UnsplashPhoto] = []
    
    var safeArea: UILayoutGuide{
        return self.view.safeAreaLayoutGuide
        
    }
    
    var buttons: [UIButton]{
        return [featuredButton, randomButton, doubleRainbowButton]
    }
    
    override func loadView(){
        super.loadView()
        addSubviews()
        setUpStackView()
        selectButton(featuredButton)
        paletteTableView.anchor(top: buttonStackView.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activateButtons()
        configureTableView()
        searchForCategory(route: .featured)
    }
    
    func setUpStackView(){
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(featuredButton)
        buttonStackView.addArrangedSubview(randomButton)
        buttonStackView.addArrangedSubview(doubleRainbowButton)
//        buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
//        buttonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
//        buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        buttonStackView.anchor(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 16, paddingBottom: 0, paddingLeft: 16, paddingRight: -16)
    }
    
    func addSubviews(){
        view.addSubview(featuredButton)
        view.addSubview(randomButton)
        view.addSubview(doubleRainbowButton)
        view.addSubview(buttonStackView)
        view.addSubview(paletteTableView)
    }
    
    func configureTableView(){
        paletteTableView.delegate = self
        paletteTableView.dataSource = self
        paletteTableView.register(PaletteTableViewCell.self, forCellReuseIdentifier: "colorCell")
        paletteTableView.allowsSelection = false
    }
    
    func searchForCategory(route: UnsplashRoute){
        UnsplashService.shared.fetchFromUnsplash(for: route) { (photos) in
            guard let photos = photos else {return}
            self.photos = photos
            DispatchQueue.main.async {
                self.paletteTableView.reloadData()
            }
        }
    }
    
    func activateButtons(){
        buttons.forEach{$0.addTarget(self, action: #selector(searchButtonTapped(sender:)), for: .touchUpInside)}
    }
    
    @objc func searchButtonTapped(sender: UIButton){
        print("tapped")
        selectButton(sender)
        switch sender{
        case featuredButton:
            searchForCategory(route: .featured)
        case randomButton:
            searchForCategory(route: .random)
        case doubleRainbowButton:
            searchForCategory(route: .doubleRainbow)
        default:
            print("how?")
        }
    }
    
    func selectButton(_ button: UIButton){
        buttons.forEach{$0.setTitleColor(.lightGray, for: .normal)}
        button.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
    }
    
    //MARK: Views
    let featuredButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Featured", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let randomButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Random", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let doubleRainbowButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Double Rainbow", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    let paletteTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
}
extension PaletteListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! PaletteTableViewCell
        let photo = photos[indexPath.row]
        cell.photo = photo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace: CGFloat = (view.frame.width - (2 * SpacingConstants.outerHorizontalPadding))
        let titleLabelSpace: CGFloat = SpacingConstants.oneLineElementHeight
        let colorPaletteSpace: CGFloat = SpacingConstants.twoLineElementHeight
        let verticalPadding: CGFloat = SpacingConstants.vertialObjectBuffer * 3
        let outerVerticalPadding: CGFloat = 2 * SpacingConstants.outerVerticalPadding
        
        return imageViewSpace + titleLabelSpace + colorPaletteSpace + verticalPadding + outerVerticalPadding
    }
    
}
