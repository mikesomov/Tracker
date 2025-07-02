//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Mike Somov on 18.06.2025.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Private properties
    
    private var pages = [UIViewController]()
    private let pageControl = UIPageControl()
    private let firstPage = 0
    private var currentIndex = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        dataSource = self
        delegate = self
    }
    
    // MARK: - Private methods
    
    private func setupContent() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = 2
        pageControl.currentPage = firstPage
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -168)
        ])
        
        let pageOne = OnboardingViewController(
            image: .onboarding1,
            buttonText: "Вот это технологии!",
            labelText: "Отлеживайте только\nто, что хотите!",
            isLastPage: false,
            buttonAction: { [weak self] in
                self?.goToNextPage()
            }
        )
        
        let pageTwo = OnboardingViewController(
            image: .onboarding2,
            buttonText: "Вот это технологии!",
            labelText: "Даже если это\nне литры воды и йога",
            isLastPage: true
        )
        
        pages = [pageOne, pageTwo]
        
        setViewControllers([pages[firstPage]], direction: .forward, animated: true, completion: nil)
    }
    
    private func goToNextPage() {
        guard currentIndex < pages.count - 1 else { return }
        currentIndex += 1
        let nextVC = pages[currentIndex]
        setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = currentIndex
    }
}

// MARK: - Extensions

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = viewControllers?.first,
              let index = pages.firstIndex(of: viewController) else { return }
        currentIndex = index
        pageControl.currentPage = index
    }
}
