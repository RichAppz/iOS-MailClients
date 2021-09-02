//
//  MailService.swift
//  iOS-MailClients
//
//  Created by Rich Mucha on 29/05/2018.
//  Copyright (c) 2018-2021 RichAppz Limited (https://richappz.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import MessageUI

public class MailService: NSObject {
    
    //================================================================================
    // MARK: Singleton
    //================================================================================
    
    private var presentation: ((UIViewController) -> Void)?
    private var presentFrom: UIViewController?
    private var subject: String?
    private var body: String?
    private var mailto: String?
    
    //================================================================================
    // MARK: Singleton
    //================================================================================
    
    private static let manager = MailService()
    
    //================================================================================
    // MARK: Helpers
    //================================================================================
    
    /**
     Use the method to request for an email to be sent this will check the users device to see what email clients are installed
     and provide a `UIAlertController` to the user to open the client. If no email clients are found on the device
     a alert will be presented and to explain this and will copy the email to the `UIPasteBoard`
     
     - Parameter fromVC: UIViewController?
     - Parameter sender: UIView?
     - Parameter subject: String?
     - Parameter subject: String?
     - Parameter body: String?
     - Parameter mailto: String?
     - Parameter noAccountTitle: String?
     - Parameter noAccountMessage: String?
     */
    public static func request(
        fromVC viewController: UIViewController?,
        sender: UIView? = nil,
        subject: String? = nil,
        body: String? = nil,
        mailto: String? = nil,
        noAccountTitle: String = "How do you check your mail?",
        noAccountMessage: String = "No email apps were found on your device.") {
        
        manager.presentFrom = viewController
        
        if let alert = fetchAlertController(
            sender: sender,
            subject: subject,
            body: body,
            mailto: mailto,
            noAccountTitle: noAccountTitle,
            noAccountMessage: noAccountMessage) {
            
            viewController?.present(
                alert,
                animated: true,
                completion: nil
            )
        }
    }
    
    /**
     --- Suits a more MVVM approach ---
     
     Use the method to request for an email to be sent this will check the users device to see what email clients are installed
     and provide a `UIAlertController` to the user to open the client. If no email clients are found on the device
     a alert will be presented and to explain this and will copy the email to the `UIPasteBoard`
     
     - Parameter sender: UIView?
     - Parameter subject: String?
     - Parameter subject: String?
     - Parameter body: String?
     - Parameter mailto: String?
     - Parameter noAccountTitle: String?
     - Parameter noAccountMessage: String?
     - Parameter presentation: @escaping (UIViewController) -> Void
     */
    public static func request(
        sender: UIView? = nil,
        subject: String? = nil,
        body: String? = nil,
        mailto: String? = nil,
        noAccountTitle: String = "How do you check your mail?",
        noAccountMessage: String = "No email apps were found on your device.",
        presentation: @escaping (UIViewController) -> Void) {
        
        manager.presentation = presentation
        
        if let alert = fetchAlertController(
            sender: sender,
            subject: subject,
            body: body,
            mailto: mailto,
            noAccountTitle: noAccountTitle,
            noAccountMessage: noAccountMessage) {
            
            presentation(alert)
        }
    }
    
    //================================================================================
    // MARK: Private
    //================================================================================
    
    fileprivate static func fetchAlertController(
        sender: UIView? = nil,
        subject: String? = nil,
        body: String? = nil,
        mailto: String? = nil,
        noAccountTitle: String,
        noAccountMessage: String) -> UIViewController? {
        
        manager.body = body
        manager.subject = subject
        manager.mailto = mailto
        
        // Sort the clients that could be available on the users device
        var availableClients = EmailClient.allCases.compactMap {
            return openAction(
                withURL: $0.rawValue,
                andTitleActionTitle: $0.display,
                scheme: composeString(client: $0)) != nil ? $0 : nil
        }
        
        let actions = EmailClient.allCases.compactMap {
            return openAction(
                withURL: $0.rawValue,
                andTitleActionTitle: $0.display,
                scheme: composeString(client: $0))
        }
        
        // If there is only one action available open
        if let action = availableClients.first, availableClients.count == 1 {
            completeAction(
                withURL: action.rawValue,
                scheme: composeString(client: action)
            )
            
            return nil
        }
        
        if actions.count > 0 {
            let alert = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: .actionSheet
            )
            
            // Insert the actions that have been allocated by the search for clients
            actions.forEach {
                alert.addAction($0)
            }

            alert.addAction(
                UIAlertAction(
                    title: .cancel,
                    style: .cancel,
                    handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }
                )
            )
            
            if
                let sender = sender,
                let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            
            return alert
        } else {
            var message = noAccountMessage
            if let mailto = mailto, mailto.count > 0 {
                UIPasteboard.general.string = mailto
                message += String(format: .copiedEmailAddress, mailto)
            }
            
            let alert = UIAlertController(
                title: noAccountTitle,
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: .ok,
                    style: .cancel,
                    handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }
                )
            )
            
            return alert
        }
    }
    
    fileprivate static func openAction(
        withURL: String,
        andTitleActionTitle: String,
        scheme: String? = nil) -> UIAlertAction? {
        
        guard
            let url = URL(string: withURL + (scheme ?? "")),
            UIApplication.shared.canOpenURL(url) else { return nil }
        
        if
            url.absoluteString.contains(EmailClient.mail.rawValue) &&
            !MFMailComposeViewController.canSendMail() {
            return nil
        }
        
        let action = UIAlertAction(
            title: andTitleActionTitle,
            style: .default) { _ in
            
            self.completeAction(
                withURL: withURL,
                scheme: scheme
            )
        }
        return action
    }
    
    fileprivate static func completeAction(
        withURL: String,
        scheme: String? = nil) {
        
        if withURL == EmailClient.mail.rawValue {
            guard let mailto = manager.mailto else {
                if let url = URL(string: "message://") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                return
            }
            
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = manager
            controller.setToRecipients([mailto])
            if let subject = manager.subject { controller.setSubject(subject) }
            if let body = manager.body { controller.setMessageBody(body, isHTML: true) }
            
            if manager.presentation != nil {
                manager.presentation?(controller)
            } else {
                manager.presentFrom?.present(
                    controller,
                    animated: true,
                    completion: nil
                )
            }
        } else {
            guard
                let url = URL(string: withURL + (scheme ?? "")),
                UIApplication.shared.canOpenURL(url) else { return }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    fileprivate static func composeString(
        client: EmailClient) -> String? {
        
        guard let mailto = manager.mailto else { return nil }
        
        /// Create string with mailto parameter and email
        var string: String = client.compose + client.mailto + mailto
        
        /// Append subject parameter if a subject line has been passed
        if let subject = manager.subject?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            string += (.and + client.subject + subject)
        }
        
        /// Append body parameter if a body has been passed
        if let body = manager.body?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            string += (.and + client.body + body)
        }
        return string
    }
    
}

//================================================================================
// MARK: MFMailComposeViewControllerDelegate
//================================================================================

extension MailService: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?) {
        
        if let error = error { debugPrint(error.localizedDescription) }
        controller.dismiss(animated: true, completion: nil)
    }
    
}
