//
//  Helper Methods.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/18/25.
//

import Foundation
import UIKit

/// asynchronous error emission helper method
func setError(_ error: Error) async {
    //UI must be updated on main thread
    await MainActor.run(body: {
        print("setError - \(error.localizedDescription)")
        showErrorAlertView("Error", error.localizedDescription, handler: {})
    })
}

func setErrorWithMessage(_ errorMessage: String, _ error: Error, handler: @escaping () -> Void, failureHandler : (() -> Void)? = nil) async {
    //UI must be updated on main thread
    await MainActor.run(body: {
        showErrorAlertView(errorMessage, error.localizedDescription, handler: handler, failureHandler: failureHandler)
        print("setErrorWithMessage - \(error.localizedDescription)")
    })
}

func showErrorAlertView (_ alertTitle: String, _ alertMessage: String, handler: @escaping () -> Void, failureHandler : (() -> Void)? = nil) {
    //should find a way to use failure handler in future
    //handler should handle when user opts to continue despite the error
    //failurehandler should handle when user wants to rectify error, like a retry calling function or going back to finish exam
    //right now this method only handles continue situations
    DispatchQueue.main.async {
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Continue", style: .cancel) { _ in handler() }
        
        alertView.addAction(ok)
        
        //Presenting
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let rootVC = window?.rootViewController
        rootVC?.present(alertView, animated: true)
        
        if (windowScene == nil) || (window == nil) || rootVC == nil {
            /// Handle failure to present alert view
            if let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })?.windows
                .first(where: { $0.isKeyWindow }) {
                
                let alertController = UIAlertController(title: "Key Window - \(alertTitle)", message: alertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in handler() })
                keyWindow.rootViewController?.present(alertController, animated: true, completion: nil)
            } else {
                /// If unable to get the key window, present the error message in the console
                print("Failed to present alert view")
            }
        }
    }
}

func showSuccessAlertView (_ alertTitle: String, _ alertMessage: String, handler: @escaping () -> Void) {
    DispatchQueue.main.async {
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in handler() }
        
        alertView.addAction(ok)
        
        //Presenting
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let rootVC = window?.rootViewController
        rootVC?.present(alertView, animated: true)
        
        if (windowScene == nil) || (window == nil) || rootVC == nil {
            /// Handle failure to present alert view
            if let keyWindow = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })?.windows
                .first(where: { $0.isKeyWindow }) {
                
                let alertController = UIAlertController(title: "Key Window - \(alertTitle)", message: alertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in handler() })
                keyWindow.rootViewController?.present(alertController, animated: true, completion: nil)
            } else {
                /// If unable to get the key window, present the error message in the console
                print("Failed to present alert view")
            }
        }
    }
}
