//
//  NewRelaseCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Lama Albadri on 30/06/2022.
//

import UIKit
import SDWebImage

class NewRelaseCollectionViewCell: UICollectionViewCell {
    static let identifer = String(describing: NewRelaseCollectionViewCell.self)
    
    private let albumCoverImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "photo")
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height-10
             let albumLabelSize = albumNameLabel.sizeThatFits(
                 CGSize(
                     width: contentView.width-imageSize-10,
                     height: contentView.height-10
                 )
             )
             artistNameLabel.sizeToFit()
             numberOfTracksLabel.sizeToFit()

             // Image
             albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)

             // Album name label
             let albumLabelHeight = min(60, albumLabelSize.height)
             albumNameLabel.frame = CGRect(
                 x: albumCoverImageView.right+10,
                 y: 5,
                 width: albumLabelSize.width,
                 height: albumLabelHeight
             )

             artistNameLabel.frame = CGRect(
                 x: albumCoverImageView.right+10,
                 y: albumNameLabel.bottom,
                 width: contentView.width - albumCoverImageView.right-10,
                 height: 30
             )

             numberOfTracksLabel.frame = CGRect(
                 x: albumCoverImageView.right+10,
                 y: contentView.bottom-44,
                 width: numberOfTracksLabel.width,
                 height: 44
             )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configureWithViewModel(with viewModel: NewRelasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artWorkURL, completed: nil)
    }
}
