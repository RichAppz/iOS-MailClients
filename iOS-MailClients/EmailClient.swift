//
//  EmailClient.swift
//  iOS-MailClients
//
//  Created by Rich Mucha on 29/05/2018.
//  Copyright © 2018 RichAppz Limited. All rights reserved.
//

import Foundation

public enum EmailClient: String {
    
    case mail = "mailto:"
    case gmail = "googlegmail:///"
    case inbox = "inbox-gmail://"
    case outlook = "ms-outlook://"
    case spark = "readdle-spark://"
    case newton = "cloudmagic://"
    
    public var display: String {
        switch self {
        case .mail: return "Mail"
        case .gmail: return "Gmail"
        case .inbox: return "Inbox"
        case .outlook: return "Outlook"
        case .spark: return "Spark"
        case .newton: return "Newton"
        }
    }
    
    public var compose: String {
        switch self {
        case .mail: return "mailto:"
        case .gmail, .inbox: return "co?"
        case .outlook, .spark, .newton:
            return "compose?"
        }
    }
    
    public var mailto: String {
        switch self {
        case .mail: return ""
        case .outlook, .gmail, .inbox, .newton:
            return "to="
        case .spark:
            return "recipient="
        }
    }
    
    public var subject: String {
        switch self {
        case .mail, .outlook, .gmail, .inbox, .spark, .newton:
            return "subject="
        }
    }
    
    public var body: String {
        switch self {
        case .mail, .outlook, .gmail, .inbox, .spark, .newton:
            return "body="
        }
    }
    
    public static var list: [EmailClient] {
        return [.mail, .gmail, .inbox, .outlook, .spark, .newton]
    }
}
