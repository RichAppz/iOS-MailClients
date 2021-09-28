//
//  EmailClient.swift
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

/**
 Schemes
 
 `Airmail` - airmail://compose?subject=[subject]&from=[from]&to=[to]&cc=[cc]&bcc=[bcc]&plainBody=[plainBody]&htmlBody=[htmlBody]
 https://help.airmailapp.com/en-us/article/airmail-ios-url-scheme-1q060gy/
 
 `Gmail` - googlegmail:///co?subject=Hello&body=Hi
 https://stackoverflow.com/questions/32114455/open-gmail-app-from-my-app
 
 `MS Outlook` - ms-outlook://compose?to=%@&subject=%@&body=%@
 https://stackoverflow.com/questions/33190891/ios-url-scheme-microsoft-outlook-app
 
 */
public enum EmailClient: String, CaseIterable {
    
    case mail = "mailto:"
    case gmail = "googlegmail:///"
    case inbox = "inbox-gmail://"
    case outlook = "ms-outlook://"
    case spark = "readdle-spark://"
    case newton = "cloudmagic://"
    case airmail = "airmail://"
    
    
    public var display: String {
        switch self {
        case .mail: return "Mail"
        case .gmail: return "Gmail"
        case .inbox: return "Inbox"
        case .outlook: return "Outlook"
        case .spark: return "Spark"
        case .newton: return "Newton"
        case .airmail: return "Airmail"
        }
    }
    
    public var compose: String {
        switch self {
        case .mail: return "mailto:"
        case .gmail, .inbox: return "co?"
        case .outlook, .spark, .newton, .airmail:
            return "compose?"
        }
    }
    
    public var mailto: String {
        switch self {
        case .mail: return ""
        case .outlook, .gmail, .inbox, .newton, .airmail:
            return "to="
        case .spark:
            return "recipient="
        }
    }
    
    public var subject: String {
        switch self {
        case .mail, .outlook, .gmail, .inbox, .spark, .newton, .airmail:
            return "subject="
        }
    }
    
    public var body: String {
        switch self {
        case .mail, .outlook, .gmail, .inbox, .spark, .newton:
            return "body="
        case .airmail:
            return "plainBody="
        }
    }
    
}
