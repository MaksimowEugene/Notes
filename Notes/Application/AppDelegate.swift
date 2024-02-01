//
//  AppDelegate.swift
//  Notes
//
//  Created by Eugene Maksimow on 26.01.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AttributedStringTransformer.register()
        setupWindow()
        setupTheme()
        
        return true
    }
    
    private func setupWindow() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let assembly = Assembly()
        let navigationController = UINavigationController()
        let router = Router(assembly: assembly, navigationController: navigationController)
        router.instantiateNotesListView()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func setupTheme() {
        let appThemeRawValue = UserDefaults.standard.string(forKey: AppThemeConstants.appThemeUDKey)
        switch appThemeRawValue {
        case AppTheme.light.rawValue:
            AppDelegate.overrideAppTheme(to: AppTheme.light)
        case AppTheme.dark.rawValue:
            AppDelegate.overrideAppTheme(to: AppTheme.dark)
        default:
            AppDelegate.overrideAppTheme(to: AppTheme.system)
        }
    }
}


// Future code for app theme settings
extension AppDelegate {
    
    static func overrideAppTheme(to appTheme: AppTheme) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        switch appTheme {
        case .light:
            UIView.animate(withDuration: 0.5) {
                window.overrideUserInterfaceStyle = .light
            }
            UserDefaults.standard.set(AppTheme.light.rawValue,
                                      forKey: AppThemeConstants.appThemeUDKey)
        case .dark:
            UIView.animate(withDuration: 0.5) {
                window.overrideUserInterfaceStyle = .dark
            }
            UserDefaults.standard.set(AppTheme.dark.rawValue,
                                      forKey: AppThemeConstants.appThemeUDKey)
        default:
            UIView.animate(withDuration: 0.5) {
                window.overrideUserInterfaceStyle = .unspecified
            }
            UserDefaults.standard.set(AppTheme.system.rawValue,
                                      forKey: AppThemeConstants.appThemeUDKey)
        }
    }
}
