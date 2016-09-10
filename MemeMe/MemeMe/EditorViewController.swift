//
//  ViewController.swift
//  MemeMe
//
//  Created by Tulio Troncoso on 8/22/16.
//  Copyright © 2016 Tulio. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    // MARK: Constants
    let CAMERA_BUTTON_TAG = 11

    // MARK: Editor Properties
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editorContainer: UIView!

    @IBOutlet weak var scrollView: UIScrollView!

    var pickerController: UIImagePickerController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make sure that we can use the camera
        if UIImagePickerController.isSourceTypeAvailable(.Camera) == false {
            bottomToolbar.viewWithTag(CAMERA_BUTTON_TAG)?.userInteractionEnabled = false
        }

        createTapRecognizerForKeyboardDismiss()

        // Auto caps on the textfields
        topTextField.autocapitalizationType = .AllCharacters
        bottomTextField.autocapitalizationType = .AllCharacters

        topTextField.delegate = self
        bottomTextField.delegate = self

        topTextField.defaultTextAttributes = NSAttributedString.memeAttributes()
        bottomTextField.defaultTextAttributes = NSAttributedString.memeAttributes()

        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center

        pickerController = UIImagePickerController()

        // Add border around editor container
        editorContainer.layer.borderWidth = 2
        editorContainer.layer.borderColor = UIColor.whiteColor().CGColor

        scrollView.minimumZoomScale=0.5;
        scrollView.maximumZoomScale=6.0;
        scrollView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {

        // Register for orientation change
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(orientationChanged),  name: UIDeviceOrientationDidChangeNotification, object: nil)

        // Register for keyboard up event
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow),  name: UIKeyboardWillShowNotification, object: nil)

        // Register for keyboard down event
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide),  name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     Creates a tap gesture recognizer for keyboard dismissal
     */
    func createTapRecognizerForKeyboardDismiss() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gr.numberOfTapsRequired = 1
        gr.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(gr)
    }

    /**
     Presents a photo picker with a given source

     - parameter sourceType: UIImagePickerControllerSourceType
     */
    func presentPickerWithSource(sourceType: UIImagePickerControllerSourceType) {

        var pickerController: UIImagePickerController

        // Init picker controller, if necessary
        if let p = self.pickerController {
            pickerController = p
        } else {
            pickerController = UIImagePickerController()
            self.pickerController = pickerController
        }

        pickerController.allowsEditing = true
        pickerController.delegate = self
        pickerController.sourceType = sourceType

        // Present
        presentViewController(pickerController, animated: true, completion: nil)
    }

    /**
     Calculates the keyboard height from NSNotification userInfo

     - parameter notification: NSNotification

     - returns: CGFloat height of the keyboard
     */
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        return keyboardRectangle.height
    }

    /**
     Generates a memed image by creating an image out of
     whatever is inside of the given view

     - parameter view: UIView that defines the frame of the image

     - returns: UIImage
     */
    func generateMemedImage(view: UIView) -> UIImage
    {

        // Remove any borders
        let borderWidth = view.layer.borderWidth
        view.layer.borderWidth = 0

        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        view.layer.borderWidth = borderWidth

        return memedImage
    }

    // MARK: Gesture Recognizer handlers
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    /**
     Shows/Hides the top and bottom toolbars

     - parameter shouldShow: Bool true if should show, false if should hide
     */
    func toggleToolbars(shouldShow: Bool) {

        topToolbar.hidden = !shouldShow
        bottomToolbar.hidden = !shouldShow

    }

    // MARK: Notification handlers

    /**
     Listens for the keyboardWillShown notification
     and moves self.view up

     - parameter notification: NSNotification
     */
    func keyboardWillShow(notification: NSNotification) {

        guard self.view.frame.origin.y == 0 else {
            return
        }

        // Move view up
        self.view.frame.origin.y -= self.getKeyboardHeight(notification)

        toggleToolbars(false)
    }

    /**
     Listens for the keyboardWillHide notification
     and moves self.view down

     - parameter notification: NSNotification
     */
    func keyboardWillHide(notification: NSNotification) {
        // Move view down
        self.view.frame.origin.y = 0
        toggleToolbars(true)
    }

    func orientationChanged(notification: NSNotification) {

    }

    // MARK: Button handlers

    /**
     Handles the tapping of the Album button
     Allows the user to choose a picture from the Photo Library

     - parameter sender: UIBarButtonItem
     */
    @IBAction func tappedAlbumButton(sender: UIBarButtonItem) {
        presentPickerWithSource(.PhotoLibrary)
    }

    /**
     Handles the tapping of a camera button. 
     Allows the user to take a picture to use for the meme

     - parameter sender: <#sender description#>
     */
    @IBAction func tappedCameraButton(sender: UIBarButtonItem) {
        presentPickerWithSource(.Camera)
    }

    /**
     Handles the tapping of the Share button. This will present
     a UIActivityViewController that lets the user pick how to 
     share the meme

     - parameter sender: UIBarButtonItem
     */
    @IBAction func tappedShareButton(sender: UIBarButtonItem) {

        if self.imageView.image != nil {

            let img = generateMemedImage(editorContainer)
            let activityController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: { 

            })
        }
    }

    /**
     Handles the tapping of the Popular button. This will present
     a view controller that will allow the user to pick a popular
     meme image

     - parameter sender: UIBarButtonItem
     */
    @IBAction func tappedPopularButton(sender: AnyObject) {

        let vc = PopularMemePickerViewController()
        vc.delegate = self

        self.presentViewController(vc, animated: true, completion: nil)
    }

    /**
     Causes the Meme Editor View to return to its launch state, 
     displaying no image and default text.

     - parameter sender: UIBarButtonItem
     */
    @IBAction func tappedCancelButton(sender: UIBarButtonItem) {
        topTextField.text = ""
        bottomTextField.text = ""
        imageView.image = nil
    }
    
}

// MARK: Image Picker Controller Delegate Extension
extension EditorViewController: UIImagePickerControllerDelegate {

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension EditorViewController: PopularMemePickerDelegate {
    func didPickMeme(meme: Meme) {
        print("Picked meme \(meme)")
        imageView.image = meme.image
    }
}

extension EditorViewController: UIScrollViewDelegate {

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}

extension EditorViewController: UINavigationControllerDelegate {

}

extension EditorViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // We want to remove all text when the user taps on the textfield
        textField.text = ""
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}

