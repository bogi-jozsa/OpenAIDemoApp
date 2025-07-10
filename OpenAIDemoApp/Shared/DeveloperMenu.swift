//
//  DeveloperMenu.swift
//  OpenAIDemoApp
//
//  Created by Boglárka Józsa on 10.07.2025.
//

import UIKit
import Scyther

class DeveloperMenu {
        
    let isEnabled: Bool
    
    init() {
        self.isEnabled = true
    }
    
    @MainActor func setup() {
        guard isEnabled else {
            return
        }
        Scyther.instance.start()
        Scyther.instance.runsOnProductionBuilds = true
        Scyther.instance.selectedGesture = .shake
    }
    
    func present(from vc: UIViewController?) {
        guard isEnabled else {
            return
        }
        Scyther.instance.selectedGesture = .custom
        Scyther.presentMenu(from: vc)
    }
    
    func enableShakeGesture() {
        guard isEnabled else {
            return
        }
        Scyther.instance.selectedGesture = .shake
    }
    
    func setupApnsToken(_ apnsToken: String) {
        guard isEnabled else {
            return
        }
        Scyther.instance.apnsToken = apnsToken
    }
    
    func setupFcmToken(_ fcmToken: String) {
        guard isEnabled else {
            return
        }
        Scyther.instance.fcmToken = fcmToken
    }
}
