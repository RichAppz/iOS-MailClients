//
//  MailService.swift
//  iOS-MailClients
//
//  Created by Rich Mucha on 29/05/2018.
//  Copyright © 2018 RichAppz Limited. All rights reserved.
//

import Foundation

import MessageUI

public class MailService: NSObject {
    
    //================================================================================
    // MARK: Singleton
    //================================================================================
    
    var presentFrom: UIViewController?
    var subject: String?
    var body: String?
    var mailto: String?
    
    //================================================================================
    // MARK: Singleton
    //================================================================================
    
    private static let manager = MailService()
    
    //================================================================================
    // MARK: Helpers
    //================================================================================
    
    public static func request(
        fromVC viewController: UIViewController?,
        subject: String? = nil,
        body: String? = nil,
        mailto: String? = nil) {
        
        manager.presentFrom = viewController
        manager.body = body
        manager.subject = subject
        manager.mailto = mailto
        
        var actions = [UIAlertAction]()
        for client in EmailClient.list {
            if let action = openAction(
                withURL: client.rawValue,
                andTitleActionTitle: client.display,
                scheme: composeString(client: client)) {
                actions.append(action)
            }
        }
        
        if actions.count > 0 {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            for action in actions { alert.addAction(action) }
            
            alert.addAction(UIAlertAction(title: .cancel, style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            manager.presentFrom?.present(alert, animated: true, completion: nil)
        } else {
            var message: String = .noEmailAccountsMessage
            if let mailto = mailto, mailto.count > 0 {
                UIPasteboard.general.string = mailto
                message += String(format: .copiedEmailAddress, mailto)
            }
            
            let alert = UIAlertController(title: .emailQuestion, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: .ok, style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            manager.presentFrom?.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate static func openAction(withURL: String, andTitleActionTitle: String, scheme: String? = nil) -> UIAlertAction? {
        guard let url = URL(string: withURL + (scheme ?? "")), UIApplication.shared.canOpenURL(url) else { return nil }
        
        let action = UIAlertAction(title: andTitleActionTitle, style: .default) { _ in
            if withURL == EmailClient.mail.rawValue {
                guard let mailto = manager.mailto else {
                    if let url = URL(string: "message://") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    return
                }
                
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = manager
                mail.setToRecipients([mailto])
                if let subject = manager.subject { mail.setSubject(subject) }
                if let body = manager.body { mail.setMessageBody(body, isHTML: true) }
                
                manager.presentFrom?.present(mail, animated: true, completion: nil)
            } else {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        return action
    }
    
    fileprivate static func composeString(client: EmailClient) -> String? {
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

extension MailService: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error { debugPrint(error.localizedDescription) }
        controller.dismiss(animated: true, completion: nil)
    }
    
}
