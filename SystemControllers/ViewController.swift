//
//  ViewController.swift
//  SystemControllers
//
//  Created by Olibo moni on 08/12/2021.
//


import UIKit
import SafariServices
import MessageUI


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
 
    let string = "some string"
    let email = "gaboahene1@gmail.com"
    let int = 90
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
    
        let activityController = UIActivityViewController(activityItems: [image,email], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        activityController.isModalInPresentation = true
        self.present(activityController, animated: true, completion: nil)
        
    }
    @IBAction func safariButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "https://www.apple.com"){
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image source", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: { _ in
        print("user cancelled")//NSLog("Opening Camera.")
        }))
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { _ in
                imagePicker.sourceType = .camera }))
            /*alert.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default, handler: { _ in
                    imagePicker.sourceType = .photoLibrary
                }))*/
                self.present(imagePicker, animated: true, completion: nil)
            NSLog("  Select between Camera and photos.") //.cancel only works on iphone
            
        } else // UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            alert.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default, handler: { _ in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            NSLog("Photo Library.")
            }))
        }
       
        alert.popoverPresentationController?.sourceView = sender
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        //configure fields of interface
        composeVC.setSubject("Hello")
        composeVC.setToRecipients(["gaboahene1@gmail.com","address@example.com"])
        composeVC.setMessageBody("Hello from this side", isHTML: false)
        
        //adding image attachment
        if let image = imageView.image, let jpegData = image.jpegData(compressionQuality: 0.9){
            composeVC.addAttachmentData(jpegData, mimeType: "image/jpg", fileName: "photo.jpg")}
        
        //present the view controller modally
        self.present(composeVC, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == MFMailComposeResult.sent{
            print("sent successfully")
        } else {
            print("please try again")
        }
        //dismiss the mail compose view controller
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func messageButtonTapped(_ sender: UIButton) {
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services not available")
            return
        }
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        //configure fields of interface
        composeVC.recipients = ["+233555552783"]
        composeVC.body = "Hello and welcome to my official youtube page."
        
        //attach image to sms
        if let image = imageView.image, let jpegData = image.jpegData(compressionQuality: 0.9){
            composeVC.addAttachmentData(jpegData, typeIdentifier: "image/jpg", filename: "photo.jpg")}
        //present the viewController modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        if result == MessageComposeResult.sent{
            print("sms sent successfully")
        }
        //dismiss the message composeView controller
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
