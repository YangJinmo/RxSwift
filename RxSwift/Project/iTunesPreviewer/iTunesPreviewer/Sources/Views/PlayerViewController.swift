//
//  PlayerViewController.swift
//  iTunesPreviewer
//
//  Created by Jmy on 2021/04/28.
//

import AVKit
import RxSwift
import UIKit

final class PlayerViewController: UIViewController {
    // MARK: - Private Constants

    private struct Image {
        static let backwardImage = UIImage(systemName: "backward.fill")
        static let pauseImage = UIImage(systemName: "pause.fill")
        static let playImage = UIImage(systemName: "play.fill")
        static let forwardImage = UIImage(systemName: "forward.fill")
    }

    private let disposeBag: DisposeBag = DisposeBag()
    private let avPlayer: AVPlayer = AVPlayer()

    // MARK: - Variables

    private var music: Music

    // MARK: - Initialization

    init(music: Music) {
        self.music = music
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI

    private let albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .label
    }

    private let artistLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .secondaryLabel
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
    }

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 48
    }

    private let backwardButton = MusicControlButton().then {
        $0.setImage(Image.backwardImage, for: .normal)
    }

    private let playAndPauseButton = MusicControlButton().then {
        $0.setImage(Image.pauseImage, for: .normal)
        $0.setImage(Image.playImage, for: .selected)
    }

    private let forwardButton = MusicControlButton().then {
        $0.setImage(Image.forwardImage, for: .normal)
    }

    // MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        configureConstraints()

        bind(music: music)
        bind()
    }

    // MARK: - Configuring

    private func configureSubviews() {
        view.backgroundColor = .systemBackground

        view.addSubviews(
            albumImageView,
            titleLabel,
            artistLabel,
            dividerView,
            stackView
        )

        stackView.addArrangedSubviews(
            backwardButton,
            playAndPauseButton,
            forwardButton
        )
    }

    private func configureConstraints() {
        albumImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(60)
            $0.width.equalTo(albumImageView.snp.height)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.bottom.equalTo(0)
        }
        stackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets).inset(120)
            $0.centerX.equalToSuperview()
        }
    }

    private func bind(music: Music) {
        albumImageView.setImage(url: music.artworkUrl100)

        titleLabel.text = music.trackName
        artistLabel.text = music.artistName

        guard let previewUrl: URL = music.previewUrl else { return }
        let avPlayerItem: AVPlayerItem = AVPlayerItem(url: previewUrl)
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        avPlayer.play()
    }

    func bind() {
        playAndPauseButton.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    guard let self = self else { return }
                    if self.playAndPauseButton.isSelected {
                        self.avPlayer.play()
                    } else {
                        self.avPlayer.pause()
                    }
                    self.playAndPauseButton.isSelected.toggle()
                }
            )
            .disposed(by: disposeBag)
    }
}
