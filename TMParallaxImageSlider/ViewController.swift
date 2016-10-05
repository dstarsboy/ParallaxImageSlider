//
//  ViewController.swift
//  TMParallaxImageSlider
//
//  Created by Travis Ma on 8/1/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import UIKit

class ParallaxCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentGroupView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.borderWidth = 1
        thumbImageView.layer.borderColor = UIColor.white().cgColor
        thumbImageView.layer.cornerRadius = 10
        thumbImageView.layer.masksToBounds = true
        contentGroupView.layer.borderWidth = 1
        contentGroupView.layer.borderColor = UIColor.lightGray().cgColor
        contentGroupView.layer.cornerRadius = 10
        contentGroupView.layer.masksToBounds = true
    }
    
}

class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let cvBounds = collectionView!.bounds
        let halfWidth = cvBounds.size.width / 2
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
            var candidateAttributes : UICollectionViewLayoutAttributes?
            for attributes in attributesForVisibleCells {
                if attributes.representedElementCategory != UICollectionElementCategory.cell {
                    continue
                }
                if let candAttrs = candidateAttributes {
                    let a = attributes.center.x - proposedContentOffsetCenterX
                    let b = candAttrs.center.x - proposedContentOffsetCenterX
                    if fabsf(Float(a)) < fabsf(Float(b)) {
                        candidateAttributes = attributes
                    }
                } else {
                    candidateAttributes = attributes
                    continue
                }
            }
            return CGPoint(x: round(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
        }
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
    
}

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let imageWidth: CGFloat = 525
    let offsetSpeed: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = self.collectionView.contentInset
        let value = (self.view.frame.size.width - (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) / 2
        insets.left = value
        insets.right = value
        self.collectionView.contentInset = insets
        //self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}

extension ViewController: UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParallaxCollectionViewCell", for: indexPath) as! ParallaxCollectionViewCell
        cell.imageView.image = UIImage(named: "\((indexPath as NSIndexPath).row)")
        cell.thumbImageView.image = UIImage(named: "\((indexPath as NSIndexPath).row)")
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let visibleCells = collectionView.visibleCells() as? [ParallaxCollectionViewCell] else { return }
        for parallaxCell in visibleCells {
            let xOffset = ((collectionView.contentOffset.x - parallaxCell.frame.origin.x) / imageWidth) * offsetSpeed
            parallaxCell.imageView.frame = parallaxCell.imageView.bounds.offsetBy(dx: xOffset, dy: 0)
        }
    }
    
}

