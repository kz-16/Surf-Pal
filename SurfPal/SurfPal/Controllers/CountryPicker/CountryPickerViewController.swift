import UIKit

class CountryPickerViewController: UIViewController {

    private let countriesCollection: UICollectionView

    init() {
        self.countriesCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
//
//    }
    
}

extension CountryPickerViewController: InitializableElement {

}
