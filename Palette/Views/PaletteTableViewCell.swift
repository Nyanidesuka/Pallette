//
//  PaletteTableViewCell.swift
//  Palette
//
//  Created by Haley Jones on 6/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {
    
    var photo: UnsplashPhoto?{
        didSet{
            updateViews()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        colorPaletterView.colors = [.gray]
    }
    
    func updateViews(){
        guard let photo = photo else {return}
        paletteTitleLabel.text = photo.description
        fetchAndSetImage(photo: photo)
        fetchAndSetColors(photo: photo)
        
    }
    
    func fetchAndSetImage(photo: UnsplashPhoto){
        UnsplashService.shared.fetchImage(for: photo) { (image) in
            DispatchQueue.main.async {
                self.paletteImageView.image = image
            }
        }
    }
    
    func fetchAndSetColors(photo: UnsplashPhoto){
        ImaggaService.shared.fetchColorsFor(imagePath: photo.urls.regular) { (colors) in
            DispatchQueue.main.async {
                guard let colors = colors else {return}
                self.colorPaletterView.colors = colors
            }
        }
    }
    
    
    func addAllSubviews(){
        addSubview(paletteImageView)
        addSubview(paletteTitleLabel)
        addSubview(colorPaletterView)
    }
    
    func setUpViews(){
        addAllSubviews()
        let imageWidth = (contentView.frame.width - (SpacingConstants.outerHorizontalPadding * 2))
        paletteImageView.anchor(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: SpacingConstants.outerVerticalPadding, paddingBottom: 0, paddingLeft: SpacingConstants.outerHorizontalPadding, paddingRight: SpacingConstants.outerHorizontalPadding, width: imageWidth, height: imageWidth)
        paletteTitleLabel.anchor(top: paletteImageView.bottomAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: SpacingConstants.vertialObjectBuffer, paddingBottom: 0, paddingLeft: SpacingConstants.outerHorizontalPadding, paddingRight: SpacingConstants.outerHorizontalPadding)
        colorPaletterView.anchor(top: paletteTitleLabel.bottomAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: SpacingConstants.vertialObjectBuffer, paddingBottom: SpacingConstants.outerVerticalPadding, paddingLeft: SpacingConstants.outerHorizontalPadding, paddingRight: SpacingConstants.outerHorizontalPadding, width: nil, height: SpacingConstants.twoLineElementHeight)
        colorPaletterView.clipsToBounds = true
        colorPaletterView.layer.cornerRadius = (SpacingConstants.twoLineElementHeight / 2)
    }

    //MARK: Subviews
    
    lazy var paletteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var paletteTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var colorPaletterView: ColorPaletteView = {
        let view = ColorPaletteView()
        return view
    }()
    
}
