
//
//  MovieDetailsVC.swift
//  Netflix Clone
//

import UIKit
import WebKit
import SafariServices

class MovieDetailsVC: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_overView: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btn_download: UIButton!
    @IBOutlet weak var btn_dismiss: UIButton!

    // MARK: - Properties

    var movies: MovieRes?
    var movieTitle: String?
    var movieOverView: String?
    var movieId: String?
    var isHidden: Bool = false

    private let thumbnailView = UIImageView()
    private let playButton = UIButton(type: .system)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTrailerPreview()
    }

    // MARK: - UI Setup

    private func setupUI() {

        view.backgroundColor = .systemBackground

        lbl_title.text = movieTitle
        lbl_overView.text = movieOverView

        btn_download.isHidden = isHidden
        btn_download.isEnabled = !isHidden

//        btn_download.addTarget(
//            self,
//            action: #selector(downloadButtonTapped),
//            for: .touchUpInside
//        )
    }

    // MARK: - Trailer Preview

    private func setupTrailerPreview() {

        webView.isHidden = true

        guard let container = webView.superview else {
            return
        }

        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true
        thumbnailView.backgroundColor = .black
        thumbnailView.isUserInteractionEnabled = true

        container.addSubview(thumbnailView)

        NSLayoutConstraint.activate([

            thumbnailView.topAnchor.constraint(
                equalTo: webView.topAnchor
            ),

            thumbnailView.bottomAnchor.constraint(
                equalTo: webView.bottomAnchor
            ),

            thumbnailView.leadingAnchor.constraint(
                equalTo: webView.leadingAnchor
            ),

            thumbnailView.trailingAnchor.constraint(
                equalTo: webView.trailingAnchor
            )
        ])

        // Dark overlay

        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.isUserInteractionEnabled = false

        thumbnailView.addSubview(overlay)

        NSLayoutConstraint.activate([

            overlay.topAnchor.constraint(
                equalTo: thumbnailView.topAnchor
            ),

            overlay.bottomAnchor.constraint(
                equalTo: thumbnailView.bottomAnchor
            ),

            overlay.leadingAnchor.constraint(
                equalTo: thumbnailView.leadingAnchor
            ),

            overlay.trailingAnchor.constraint(
                equalTo: thumbnailView.trailingAnchor
            )
        ])

        // Play button

        playButton.setImage(
            UIImage(systemName: "play.fill"),
            for: .normal
        )

        playButton.tintColor = .white
        playButton.backgroundColor = .systemRed
        playButton.layer.cornerRadius = 35

        playButton.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(playButton)

        NSLayoutConstraint.activate([

            playButton.centerXAnchor.constraint(
                equalTo: thumbnailView.centerXAnchor
            ),

            playButton.centerYAnchor.constraint(
                equalTo: thumbnailView.centerYAnchor
            ),

            playButton.widthAnchor.constraint(
                equalToConstant: 70
            ),

            playButton.heightAnchor.constraint(
                equalToConstant: 70
            )
        ])

        playButton.addTarget(
            self,
            action: #selector(playTrailerTapped),
            for: .touchUpInside
        )

        loadThumbnail()
    }

    // MARK: - Load YouTube Thumbnail

    private func loadThumbnail() {

        guard let videoId = movieId,
              !videoId.isEmpty,
              let url = URL(
                string: "https://img.youtube.com/vi/\(videoId)/hqdefault.jpg"
              ) else {

            print("Invalid YouTube thumbnail URL")
            return
        }

        URLSession.shared.dataTask(with: url) {
            [weak self] data, response, error in

            if let error = error {
                print("Thumbnail error: \(error)")
                return
            }

            guard let data = data,
                  let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self?.thumbnailView.image = image
            }

        }.resume()
    }

    // MARK: - Play Trailer

    @objc private func playTrailerTapped() {

        guard let videoId = movieId,
              !videoId.isEmpty,
              var components = URLComponents(
                string: "https://www.youtube.com/watch"
              ) else {

            print("Invalid YouTube video ID")
            return
        }

        components.queryItems = [
            URLQueryItem(name: "v", value: videoId)
        ]

        guard let url = components.url else {
            return
        }

        let safariVC = SFSafariViewController(url: url)

        safariVC.modalPresentationStyle = .fullScreen

        present(safariVC, animated: true)
    }

    // MARK: - Download Button

    @objc private func downloadButtonTapped() {
        saveMovie()
    }

    // Keep this IBAction for existing Storyboard connections.
    @IBAction func download(_ sender: UIButton) {
        saveMovie()
    }

    private func saveMovie() {

        guard let movie = movies else {

            print("ERROR: Movie object is nil")

            showAlert(
                title: "Unable to Save",
                message: "Movie information is missing."
            )

            return
        }

        print("Saving movie: \(movie.originalTitle ?? "Unknown")")

        CoreDataManager.shared.downloadMovie(with: movie) {
            [weak self] result in

            DispatchQueue.main.async {

                switch result {

                case .success:

                    print("Movie saved successfully")

                    self?.showAlert(
                        title: "Added to Favourites!",
                        message: "Movie saved successfully."
                    )

                case .failure(let error):

                    print("Core Data error: \(error)")

                    self?.showAlert(
                        title: "Download Failed",
                        message: error.localizedDescription
                    )
                }
            }
        }
    }

    // MARK: - Alert

    private func showAlert(
        title: String,
        message: String
    ) {

        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }

    // MARK: - Dismiss

    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
