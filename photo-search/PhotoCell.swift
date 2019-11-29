//
//  PhotoCell.swift
//  
//
//  Created by Hendrik brutsaert on 11/27/19.
//

import UIKit
import Stevia

class PhotoCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.text = "Custom Text"
        return label
    }()
    let imageView = UIImageView()
    private var imageDataTask: URLSessionDataTask?
    private static var cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "unsplash")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(label)
        sv(label, imageView)
        label.centerHorizontally().bottom(10)
        imageView.top(10).left(10).right(10)
        label.Top == imageView.Bottom
        imageView.image = UIImage(named: "Image")
    }

    func downloadPhoto(_ photo: Photo) {
        guard let url = photo.urls[.regular] else { return }

        if let cachedResponse = PhotoCell.cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {
            imageView.image = image
            return
        }

        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }

            strongSelf.imageDataTask = nil

            guard let data = data, let image = UIImage(data: data), error == nil else { return }

            DispatchQueue.main.async {
                UIView.transition(with: strongSelf.imageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.imageView.image = image
                }, completion: nil)
            }
        }

        imageDataTask?.resume()
    }

}
