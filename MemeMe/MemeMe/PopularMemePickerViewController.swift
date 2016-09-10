//
//  PopularMemePickerViewController.swift
//  MemeMe
//
//  Created by Tulio Troncoso on 9/10/16.
//  Copyright © 2016 Tulio. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

class PopularMemePickerViewController: UICollectionViewController {

    var delegate: PopularMemePickerDelegate?
    var availableMemes: [Meme] = []

    convenience init() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // Setting the space between cells
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.headerReferenceSize = CGSizeMake(40, 44)

        let screenWidth = UIScreen.mainScreen().bounds.width
        var itemSize = screenWidth
        itemSize = itemSize / 2
        itemSize = itemSize - (1.5 * 10)
        layout.itemSize = CGSizeMake(itemSize, itemSize)

        self.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        collectionView?.registerClass(MemePickerCollectionViewCell.self, forCellWithReuseIdentifier: "MemePickerCellReuseIdentifier")

        collectionView?.backgroundColor = UIColor.lightGrayColor()

        var myRootRef = FIRDatabase.database().reference().child("/images")

        myRootRef.observeEventType(.Value, withBlock: { (snapshot) in
            print("\(snapshot.key) -> \(snapshot.value)")

            if let enumerator = snapshot.value?.objectEnumerator() {
                enumerator.forEach({ (obj) in

                    var alreadyHaveIt = self.availableMemes.contains({ (meme) -> Bool in
                        meme.name == obj.name
                    })

                    guard (alreadyHaveIt == false) else {
                        return
                    }

                    if let downloadUrl = obj.objectForKey("storage-location") {

                        let picRef = FIRStorage.storage().referenceForURL(downloadUrl as! String)

                        picRef.dataWithMaxSize(4 * 1024 * 1024, completion: { (data, error) in

                            if let downloadedImage: UIImage = UIImage(data: data!) {

                                self.availableMemes.append(Meme(name: obj.objectForKey("display-name") as? String, image: downloadedImage, topText: "", bottomText: "", memedImage: nil))
                                    
                                self.collectionView?.reloadData()
                            }
                            
                        })
                    }

                })
            }

        })


    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableMemes.count
    }

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemePickerCellReuseIdentifier", forIndexPath: indexPath) as! MemePickerCollectionViewCell

        cell.backgroundView = UIImageView(image: availableMemes[indexPath.row].image)

        return cell
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        delegate?.didPickMeme(availableMemes[indexPath.row])
        delegate?.didCancel()
    }
}

protocol PopularMemePickerDelegate {
    func didPickMeme(meme: Meme)
    func didCancel()
}

extension PopularMemePickerDelegate where Self : UIViewController{
    func didCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}