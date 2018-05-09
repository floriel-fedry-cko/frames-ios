import Foundation

public protocol CountrySelectionViewControllerDelegate: class {
    func onCountrySelected(country: String)
}
