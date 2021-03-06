//
//  TrackCell.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import UIKit

final class MusicCell: BaseCollectionViewCell {
    // MARK: - Views

    private let albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }

    private let artistLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
    }

    // MARK: - View Life Cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = ""
        artistLabel.text = ""
        albumImageView.image = nil
    }

    override func setupViews() {
        super.setupViews()
        
        contentView.addSubviews(
            albumImageView,
            titleLabel,
            artistLabel,
            dividerView
        )
        
        albumImageView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(100)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.top)
            $0.left.equalTo(albumImageView.snp.right).offset(8)
            $0.right.equalToSuperview().inset(8)
        }
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(titleLabel.snp.left)
        }
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: - Variables And Properties

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .secondarySystemBackground : .systemBackground
        }
    }

    // MARK: - Internal Methods

    func bind(music: Music) {
        albumImageView.setImage(url: music.artworkUrl100)

        titleLabel.text = music.trackName
        artistLabel.text = music.artistName
    }
}
