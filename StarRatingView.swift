//
//  StarRatingView.swift
//  Star Rating View
//
//  Created by Roberth H-T on 2018-02-05.
//  Copyright © 2018 Roberth Hansson-Tornéus. All rights reserved.
//

import UIKit

// MARK - Types
enum StarType: String {
    
    case emptyStar = "emptyStar", halfStar = "halfStar", filledStar = "filledStar"
    
    var toImage: UIImage { return UIImage(named: self.rawValue)!.withRenderingMode(.alwaysTemplate)/* allows tinting */ }
}


/// # Star Rating View
/// A dynamic star rating view
/// - author: Roberth Hansson-Tornéus
/// - copyright: `Copyright © 2018 Roberth Hansson-Tornéus. All rights reserved.`
public class StarRatingView: UIView {
    
    // MARK: - Properties
    
    private var _starCount: Int = 5
    private var _rating: Double = 0
    
    private var starRatingStackView: UIStackView!
    
    var hasDropShadow = false {
        didSet {
            if starRatingStackView != nil {
                updateDropShadow()
            }
        }
    }
    
    
    // MARK: - Initializers
    
    convenience init(frame: CGRect, starCount: Int = 5, rating: Double = 0.0) {
        self.init(frame: frame)
        _starCount = starCount
        _rating = rating
    }
    
    convenience init(starCount: Int = 5, rating: Double = 0.0) {
        self.init()
        _starCount = starCount
        _rating = rating
    }
    
    
    // MARK: - Lifecycle
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupViews()
    }
}

// MARK: - Methods
extension StarRatingView {
    
    // MARK: Setup View
    
    /// Setups the main views
    private func setupViews() {
        
        let starRatingStackView = createStarRatingStackView()
        addSubview(starRatingStackView)
        starRatingStackView.translatesAutoresizingMaskIntoConstraints = false
        starRatingStackView.tintColor = .yellow
        
        NSLayoutConstraint.activate([
            starRatingStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            starRatingStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            starRatingStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            starRatingStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
            ])
        
        updateDropShadow()
        self.starRatingStackView = starRatingStackView
    }
    
    
    /// Update View
    ///
    /// - Parameters:
    ///   - starCount: (Optional) Sets a new star count. Use this if you want to increase the number of stars to display.
    ///   - rating: Sets a new star rating.
    public func updateView(starCount: Int? = nil, rating: Double) {
        
        _rating = rating
        
        if let starCount = starCount {
            _starCount = starCount
            starRatingStackView.removeFromSuperview()
            setupViews()
            updateDropShadow()
            return
        }
        
        if starRatingStackView?.arrangedSubviews.count != 0 {
            
            updateStarImageViews()
        }
    }
    
    fileprivate func updateStarImageViews() {
        
        var starTyper = StarTypeIterator(rating: _rating)
        
        starRatingStackView.arrangedSubviews.forEach { ($0 as! UIImageView).image = starTyper.next().toImage }
    }
    
    fileprivate func createStarRatingStackView() -> UIStackView {
        
        let stackView = UIStackView(arrangedSubviews: createStarImageViews())
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }
    
    fileprivate func createStarImageViews() -> [UIImageView] {
        
        var starViews = [UIImageView]()
        var starTyper = StarTypeIterator(rating: _rating)
        
        (0..<_starCount).forEach { [weak self] index in
            
            guard let strongSelf = self else { return }
            
            starViews.append(strongSelf.createStarImageView(tag: (index + 1), using: starTyper.next()))
        }
        
        return starViews
    }
    
    fileprivate func createStarImageView(tag: Int, using starType: StarType) -> UIImageView {
        
        let starImageView = UIImageView(frame: .init(x: 0, y: 0, width: 8, height: 8))
        starImageView.contentMode = .scaleAspectFit
        starImageView.image = starType.toImage
        
        return starImageView
    }
    
    fileprivate func addShadow() {
        
        guard let starRatingStackView = self.starRatingStackView else { return }
        
        starRatingStackView.arrangedSubviews.forEach {
            let layer = $0.layer
            layer.shadowColor = UIColor.darkGray.cgColor
            layer.shadowOffset = CGSize(width: -0.5, height: 0.5)
            layer.shadowRadius = 0.5
            layer.shadowOpacity = 0.5
        }
    }
    
    fileprivate func removeShadow() {
        
        guard let starRatingStackView = self.starRatingStackView else { return }
        
        starRatingStackView.arrangedSubviews.forEach {
            let layer = $0.layer
            layer.shadowColor = nil
            layer.shadowOffset = .zero
            layer.shadowRadius = 0
            layer.shadowOpacity = 0
        }
    }
    
    fileprivate func updateDropShadow() {
        
        (self.hasDropShadow) ? addShadow() : removeShadow()
    }
}

// MARK: - Iterators
extension StarRatingView {
    
    private struct StarTypeIterator {
        
        fileprivate var _tempRating: Double
        fileprivate var _initialRating: Double
        
        init(rating: Double) {
            _tempRating = rating
            _initialRating = rating
        }
        
        mutating func set(newRating: Double) {
            _tempRating = newRating
            _initialRating = newRating
        }
        
        mutating func next() -> StarType {
            if _tempRating >= 1 {
                _tempRating -= 1
                return .filledStar
            } else if (_tempRating != 0) && (_tempRating < 1)  {
                _tempRating = 0
                return .halfStar
            }
            return .emptyStar
        }
        
        mutating func reset() {
            _tempRating = _initialRating
        }
    }
}
