//
//  CustomModalViewController.swift
//  gorene
//
//  Created by Illya Blinov & GPT-5 on 12.10.25.
//

import UIKit

final class CustomModalViewController: UIViewController {

    private var modalViews: [ShowModalViewProtocol] = []
    private var currentIndex = 0
    private var currentView: UIView?

    // MARK: - Init
    init(modalViews: [ShowModalViewProtocol]) {
        self.modalViews = modalViews
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        isModalInPresentation = true // блокируем системный dismiss по свайпу
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentModal(animated: false)
    }

    // MARK: - Core logic
    private func showCurrentModal(animated: Bool = true) {
        guard currentIndex < modalViews.count else {
            debugPrint("✅ Все модальные окна показаны. Закрываем CustomModalViewController.")
            dismiss(animated: true)
            return
        }

        // Удаляем предыдущую view, если была
        currentView?.removeFromSuperview()

        guard let modalView = modalViews[currentIndex] as? UIView else {
            debugPrint("⚠️ modalView \(currentIndex) не является UIView")
            return
        }
        view.backgroundColor = modalView.backgroundColor
        modalView.translatesAutoresizingMaskIntoConstraints = false
        modalView.alpha = 1
        modalView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96) // лёгкий зум-эффект при появлении
        view.addSubview(modalView)
        currentView = modalView

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            modalView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            modalView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            modalView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        // мягкое появление
        let duration: TimeInterval = animated ? 0.45 : 0
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.6,
                       options: [.curveEaseInOut],
                       animations: {
            modalView.alpha = 1
            modalView.transform = .identity
        })

        // свайп вниз для закрытия текущей view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        modalView.addGestureRecognizer(pan)
    }

    // MARK: - Gesture logic
    @objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        guard let targetView = gesture.view else { return }
        let translation = gesture.translation(in: targetView)

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                targetView.transform = CGAffineTransform(translationX: 0, y: translation.y / 2)
            }

        case .ended:
            if translation.y > 120 {
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                    targetView.alpha = 0
                    targetView.transform = CGAffineTransform(translationX: 0, y: targetView.frame.height * 1.2)
                }) { _ in
                    self.closeCurrentModal()
                }
            } else {
                UIView.animate(withDuration: 0.35,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.5,
                               options: [.curveEaseInOut],
                               animations: {
                    targetView.transform = .identity
                })
            }

        default:
            break
        }
    }

    // MARK: - Close logic
    private func closeCurrentModal() {
        guard currentIndex < modalViews.count else { return }

        currentIndex += 1

        if currentIndex < modalViews.count {
            UIView.transition(with: view,
                              duration: 0.5,
                              options: [.transitionCrossDissolve, .curveEaseInOut],
                              animations: {
                self.showCurrentModal(animated: true)
            })
        } else {
            debugPrint("🟦 Стек окон закончился. Dismiss CustomModalViewController.")
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                self.view.alpha = 0
            }) { _ in
                self.dismiss(animated: false)
            }
        }
    }
}

