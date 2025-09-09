//  BoardController.swift
//  Wordle
//
//  Created by Mari Batilando on 2/20/23.
//

import Foundation
import UIKit

class BoardController: NSObject,
                       UICollectionViewDataSource,
                       UICollectionViewDelegate,
                       UICollectionViewDelegateFlowLayout {
  
  // MARK: - Properties
  var numItemsPerRow = 5
  var numRows = 6
  let collectionView: UICollectionView
  var goalWord: [String]

  var numTimesGuessed = 0
  var isAlienWordle = false
  var currRow: Int {
    return numTimesGuessed / numItemsPerRow
  }
  
  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    let rawTheme = SettingsManager.shared.settingsDictionary[kWordThemeKey] as! String
    let theme = WordTheme(rawValue: rawTheme)!
    self.goalWord = WordGenerator.generateGoalWord(with: theme)
    super.init()
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  // MARK: - Public Methods
  func resetBoard(with settings: [String: Any]) {
    applyNumLettersSettings(with: settings)
    applyNumGuessesSettings(with: settings)
    applyThemeSettings(with: settings)
    applyIsAlienWordleSettings(with: settings)
    numTimesGuessed = 0
    collectionView.reloadData()
  }
  
  // Exercise 5 Pt. 2 (optional): This function only needs to be implemented if you decide to do the optional requirement (see Pt. 1 in ViewController.swift)
  // This function should reset the board with the current settings without changing the goalWord
  // Tip: Take a look at how resetBoard is implemented above. The only difference is that you don't want to change the settings
  func resetBoardWithCurrentSettings() {
    let settings = SettingsManager.shared.settingsDictionary
    applyNumLettersSettings(with: settings)
    applyNumGuessesSettings(with: settings)
    applyIsAlienWordleSettings(with: settings) // Do NOT change theme/goal word
    numTimesGuessed = 0
    collectionView.reloadData()
  }
  
  // Exercise 1: Implement applyNumLettersSettings to change the number of letters in the goal word
  private func applyNumLettersSettings(with settings: [String: Any]) {
    if let n = settings[kNumLettersKey] as? Int {
      numItemsPerRow = n
    } else if let s = settings[kNumLettersKey] as? String, let n = Int(s) {
      numItemsPerRow = n
    }
  }
  
  // Exercise 2: Implement applyNumGuessesSettings to change the number of rows in the board
  private func applyNumGuessesSettings(with settings: [String: Any]) {
    if let r = settings[kNumGuessesKey] as? Int {
      numRows = r
    } else if let s = settings[kNumGuessesKey] as? String, let r = Int(s) {
      numRows = r
    }
  }
  
  // Exercise 3: Implement applyThemeSettings to change the goal word according to the theme
  private func applyThemeSettings(with settings: [String: Any]) {
    guard let raw = settings[kWordThemeKey] as? String,
          let theme = WordTheme(rawValue: raw) else { return }
    goalWord = WordGenerator.generateGoalWord(with: theme)
  }
  
  // Exercise 4: Implement applyIsAlienWordleSettings to change the goal word after each guess
  private func applyIsAlienWordleSettings(with settings: [String: Any]) {
    if let b = settings[kIsAlienWordleKey] as? Bool {
      isAlienWordle = b
    } else if let s = settings[kIsAlienWordleKey] as? String {
      isAlienWordle = (s as NSString).boolValue   // handles "true"/"false", "1"/"0"
    } else if let n = settings[kIsAlienWordleKey] as? NSNumber {
      isAlienWordle = n.boolValue
    }
  }
}

