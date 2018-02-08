# StarRatingView #
A Dynamic Star Rating View in Pure Swift by R-H-T

---

## Getting Started ##

This view can be initialized either by code or be included in your storyboard or nib.

**In Code:**

```swift
    
    // MARK: - Methods
    
    fileprivate func setupStarRatingView() {
        
        let starRatingView = StarRatingView(starCount: 5, rating: 5)
        
        view.addSubview(starRatingView)
        
        starRatingView.hasDropShadow = true
        
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starRatingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            starRatingView.heightAnchor.constraint(equalToConstant: 48),
            starRatingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            starRatingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ])
        
        self.starRatingView = starRatingView
    }
    
```

**For Storyboards:**
```swift
// ViewController.swift
    
    /* ... */

    // MARK: - Properties
    
    // MARK: Outlets
    @IBOutlet weak var starRatingView: StarRatingView!

    /* ... */

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starRatingView.hasDropShadow = true
        starRatingView.updateView(rating: 4.5)
    }
```
#### Images ####
You'll need to provide three images in your assets folder representing each
of the star's 3 main states (`emptyStar`, `halfStar`, `filledStar`).

---

### License ###
_TBD_ (To be determined)

Copyright © 2018 Roberth Hansson-Tornéus. All rights reserved.
