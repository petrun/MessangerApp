import Foundation

/// Конструктор функций для добавления дочерних вьюшек в иерархичном виде
@_functionBuilder
public struct AddViewBuilder {
    public static func buildBlock(_ views: UIView...) -> [UIView] {
        views
    }

    public static func buildBlock(_ view: UIView) -> [UIView] {
        [view]
    }
}

/// Расширение для добавления дочерних вьюшек в иерархичном виде
extension UIView {
    /// Добавить несколько вьюшек
    /// - Parameter block: Блок, возвращающий массив вьюшек
    @discardableResult
    public func add(@AddViewBuilder _ block: () -> ([UIView])) -> UIView {
        if let stackView = self as? UIStackView {
            block().forEach { stackView.addArrangedSubview($0) }
        } else {
            block().forEach { addSubview($0) }
        }
        return self
    }

    /// Добавить одну вьюшку
    /// - Parameter block: Блок, возвращающий вьюшку
    @discardableResult
    public func add(@AddViewBuilder _ block: () -> (UIView)) -> UIView {
        if let stackView = self as? UIStackView {
            stackView.addArrangedSubview(block())
        } else {
            addSubview(block())
        }
        return self
    }

    /// Добавить одну вьюшку и добавить к ней констреинты, согласно инсетам
    /// - Parameter insets: Инсеты дочерней вьюшки
    /// - Parameter block: Блок, возвращающий вьюшку
    @discardableResult
    public func add(insets: UIEdgeInsets, @AddViewBuilder _ block: () -> (UIView)) -> UIView {
        let view = block()
        add { view }
        view.snp.makeConstraints {
            $0.top.equalToSuperview().inset(insets.top)
            $0.bottom.equalToSuperview().inset(insets.bottom)
            $0.leading.equalToSuperview().inset(insets.left)
            $0.trailing.equalToSuperview().inset(insets.right)
        }
        return self
    }

    /// Вставляет одну вьюшку по индексу
    /// - Parameter index: Индекс вставки вьюшки
    /// - Parameter block: Блок, возвращающий вьюшку
    @discardableResult
    public func insert(at index: Int, @AddViewBuilder _ block: () -> (UIView)) -> UIView {
        if let stackView = self as? UIStackView {
            stackView.insertArrangedSubview(block(), at: index)
        } else {
            insertSubview(block(), at: index)
        }
        return self
    }
}
