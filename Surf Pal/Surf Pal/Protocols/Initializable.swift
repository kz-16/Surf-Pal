protocol Initializable {
    func initialize()
}

protocol Configurable {
    func addViews()
    func configureAppearance()
    func configureLayout()
}

extension Configurable {
    func addViews() {}
    func configureAppearance() {}
    func configureLayout() {}
}

extension Initializable where Self: Configurable {
    func initialize() {
        addViews()
        configureLayout()
        configureAppearance()
    }
}

typealias InitializableElement = Initializable & Configurable
