//
//  MainViewExtension.swift
//  gorene
//
//  Created by Illya Blinov on 4.02.24.
//

import UIKit
extension MainView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = actionButtons.count
        return section
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
                                                    TableButtonViewCell.identifier, for: indexPath) as!  TableButtonViewCell
        cell.setupCell(actionButtonTitle: actionButtons[indexPath.row], isEnable: true, detailsIsOff: (detailsButtons[indexPath.row] == nil))
        cell.actionButtonAction = {[weak self] in
            guard let self else { return }
            self.mainPresenter.actionPressed(action: indexPath.row) }
        cell.detailsButtonAction = { [weak self] in
            guard let self else { return }
            self.showDetails(details: self.detailsButtons[indexPath.row] , action: self.actionButtons[indexPath.row])
        }
        cell.appleColorTheme(colors: themeColor)
        return cell
    }

    func detailsConstraints(_ state: Int = 1){
        let defaultIndent: CGFloat = 12
        let constraints = [detailsTitleLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: defaultIndent),
                           detailsTitleLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -defaultIndent),
                           detailsTitleLabel.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: defaultIndent),
                           detailsLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: defaultIndent),
                           detailsLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -defaultIndent),
                           detailsLabel.topAnchor.constraint(equalTo: detailsTitleLabel.bottomAnchor, constant: defaultIndent)]
        if state == 1 { NSLayoutConstraint.activate(constraints)}
        if state == 0 { NSLayoutConstraint.deactivate(constraints)}
    }

    func setupConstraints(){
        let safeArea = view.safeAreaLayoutGuide
        let defaultIndent: CGFloat = 12
        let nearIndent: CGFloat = 3
        let topLineHeight: CGFloat = 56
        let bottomLineHeight: CGFloat = 226
        let buttonHeight: CGFloat = 50
        NSLayoutConstraint.activate([
            //MARK: top view group
            informationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: defaultIndent),
            informationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -defaultIndent),
            informationView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: defaultIndent),
            informationView.heightAnchor.constraint(equalToConstant: topLineHeight),

            locationLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: defaultIndent),
            locationLabel.topAnchor.constraint(equalTo: informationView.topAnchor, constant: defaultIndent / 2),

            statusLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: defaultIndent),
            statusLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: defaultIndent / 2),

            settingsButton.topAnchor.constraint(equalTo: informationView.topAnchor, constant: nearIndent),
            settingsButton.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: -nearIndent),
            settingsButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            settingsButton.widthAnchor.constraint(equalTo: settingsButton.heightAnchor),
            //MARK: main view group
            mainTextView.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: defaultIndent),
            mainTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: defaultIndent),
            mainTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -defaultIndent),
            mainTextView.bottomAnchor.constraint(equalTo: playButtonTable.topAnchor, constant: -defaultIndent),

            mainTextLabel.topAnchor.constraint(equalTo: mainTextView.topAnchor, constant: defaultIndent / 2),
            mainTextLabel.bottomAnchor.constraint(equalTo: mainTextView.bottomAnchor, constant: -defaultIndent / 2),
            mainTextLabel.leadingAnchor.constraint(equalTo: mainTextView.leadingAnchor, constant: defaultIndent),
            //mainTextLabel.trailingAnchor.constraint(equalTo: mainTextView.trailingAnchor, constant: -defaultIndent),
            mainTextLabel.widthAnchor.constraint(equalTo: mainTextView.widthAnchor, constant: -defaultIndent * 2),
            //MARK: botttom view group
            playButtonTable.leadingAnchor.constraint(equalTo: playerButton.trailingAnchor, constant: defaultIndent),
            playButtonTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -defaultIndent),
            playButtonTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -defaultIndent),
            playButtonTable.heightAnchor.constraint(equalToConstant: bottomLineHeight),

            playerButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: defaultIndent),
            playerButton.topAnchor.constraint(equalTo: playButtonTable.topAnchor, constant: nearIndent),
            playerButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            playerButton.widthAnchor.constraint(equalTo: playerButton.heightAnchor),

            saveButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: defaultIndent),
            saveButton.topAnchor.constraint(equalTo: playerButton.bottomAnchor, constant: nearIndent * 2),
            saveButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            saveButton.widthAnchor.constraint(equalTo: saveButton.heightAnchor),

            loadButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: defaultIndent),
            loadButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: nearIndent * 2),
            loadButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            loadButton.widthAnchor.constraint(equalTo: loadButton.heightAnchor),

            //    buttonCountView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: //defaultIndent),
            //     buttonCountView.bottomAnchor.constraint(equalTo: playButtonTable.bottomAnchor, constant: -nearIndent),
            //     buttonCountView.heightAnchor.constraint(equalToConstant: buttonHeight),
            //    buttonCountView.widthAnchor.constraint(equalTo: buttonCountView.heightAnchor),
        ])
    }

}
