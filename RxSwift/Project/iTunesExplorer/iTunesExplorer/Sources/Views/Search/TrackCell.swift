//
//  TrackCell.swift
//  iTunesExplorer
//
//  Created by Jmy on 2021/04/21.
//

import UIKit

protocol TrackCellDelegate {
    func cancelTapped(_ cell: TrackCell)
    func downloadTapped(_ cell: TrackCell)
    func pauseTapped(_ cell: TrackCell)
    func resumeTapped(_ cell: TrackCell)
}

final class TrackCell: BaseCollectionViewCell {
    // MARK: - UI

    private let albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .label
        $0.numberOfLines = 0
    }

    private let artistLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
    }

    private let cancelButton = UIButton().then {
        $0.setTitleColor(.tintColor, for: .normal)
        $0.setTitle("Cancel", for: .normal)
    }

    private let downloadButton = UIButton().then {
        $0.setTitleColor(.tintColor, for: .normal)
        $0.setTitle("Download", for: .normal)
    }

    private let pauseButton = UIButton().then {
        $0.setTitleColor(.tintColor, for: .normal)
        $0.setTitle("Pause", for: .normal)
    }

    private let progressLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = .secondaryLabel
    }

    private let progressView = UIProgressView().then {
        $0.progressTintColor = .tintColor
        $0.trackTintColor = .secondarySystemBackground
        $0.progress = 0.0
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
    }

    // MARK: - View Controller

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = ""
        artistLabel.text = ""
        progressLabel.text = ""
        albumImageView.image = nil
    }

    override func setupViews() {
        super.setupViews()

        configureSubviews()
        configureConstraints()
        configureGesture()
    }

    // MARK: - Configuring

    private func configureSubviews() {
        contentView.addSubviews(
            albumImageView,
            titleLabel,
            artistLabel,
            downloadButton,
            cancelButton,
            pauseButton,
            progressView,
            progressLabel,
            dividerView
        )
    }

    private func configureConstraints() {
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
        downloadButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
        }
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
        }
        pauseButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(cancelButton.snp.left).offset(-8)
        }
        progressView.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.left)
            $0.bottom.equalToSuperview().inset(8)
            $0.right.equalTo(progressLabel.snp.left).offset(-8)
        }
        progressLabel.snp.makeConstraints {
            $0.right.bottom.equalToSuperview().inset(8)
            $0.width.equalTo(100)
        }
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.bottom.equalTo(0)
        }
    }

    private func configureGesture() {
        cancelButton.addTarget(self, action: #selector(cancelTapped(_:)))
        downloadButton.addTarget(self, action: #selector(downloadTapped(_:)))
        pauseButton.addTarget(self, action: #selector(pauseOrResumeTapped(_:)))
    }

    // MARK: - Variables And Properties

    /// Delegate identifies track for this cell, then
    /// passes this to a download service method.
    var delegate: TrackCellDelegate?

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .secondarySystemBackground : .systemBackground
        }
    }

    // MARK: - Actions

    @objc func cancelTapped(_ sender: AnyObject) {
        delegate?.cancelTapped(self)
    }

    @objc func downloadTapped(_ sender: AnyObject) {
        delegate?.downloadTapped(self)
    }

    @objc func pauseOrResumeTapped(_ sender: AnyObject) {
        if pauseButton.titleLabel?.text == "Pause" {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }

    // MARK: - Internal Methods

    func configure(track: Track, download: Download?) {
        albumImageView.setImage(url: track.artworkUrl100)
        // albumImageView.downloadImage(url: track.artworkUrl100)

        titleLabel.text = track.trackName
        artistLabel.text = track.artistName

        // Show/hide download controls Pause/Resume, Cancel buttons, progress info.
        var showDownloadControls = false

        // Non-nil Download object means a download is in progress.
        if let download = download {
            showDownloadControls = true

            let title = download.isDownloading ? "Pause" : "Resume"
            pauseButton.setTitle(title, for: .normal)

            progressLabel.text = download.isDownloading ? "Downloading..." : "Paused"
        }

        pauseButton.isHidden = !showDownloadControls
        cancelButton.isHidden = !showDownloadControls

        progressView.isHidden = !showDownloadControls
        progressLabel.isHidden = !showDownloadControls

        // If the track is already downloaded, enable cell selection and hide the Download button.
        // selectionStyle = track.downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none

        let flag = track.downloaded || showDownloadControls
        downloadButton.isHidden = flag
        // downloadButton.isEnabled = !flag
        // downloadButton.setTitle(flag ? "Play" : "Download", for: .normal)
        // downloadButton.setTitleColor(flag ? .tintColor : .systemPurple, for: .normal)
    }

    func updateDisplay(progress: Float, totalSize: String) {
        progressView.progress = progress
        progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
}
