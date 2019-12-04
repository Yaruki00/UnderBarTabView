# UnderBarTabView

## 概要
選択した箇所に下線が来るようなタブです。  
![normal](https://github.com/Yaruki00/UnderBarTabView/blob/master/gif/normal.gif)
![infinite](https://github.com/Yaruki00/UnderBarTabView/blob/master/gif/infinite.gif)

デモのgifではわかりやすくするために下の部分(UIScrollView)を作っていますが、このリポジトリが対象としているのはタブのみです。

## 依存
内部でRxSwiftとReusableを利用しています。  
[RxSwift](https://github.com/ReactiveX/RxSwift)  
[Reusable](https://github.com/AliSoftware/Reusable)

## ディレクトリ構成(重要な箇所だけ)
`UnderBarTab/Library/` タブのコードが入ってます。  
`UnderBarTab/Presentation/` サンプルのコードが入ってます。

## カスタマイズ
`UnderBarTabViewConfig`と`UnderBarTabCellConfig`のconfigクラスがあります。
```Swift
/// ビュー全体の設定
struct UnderBarTabViewConfig {
    /// .fixed(width:) ⇒ すべてのタブは固定幅、.flexible(margin:) ⇒ 文字列の幅に応じてタブの幅も可変
    let type: UnderBarTabWidthType
    /// ビュー全体の余白
    let insets: UIEdgeInsets
    /// タブ間の余白
    let itemSpacing: CGFloat
    /// 選択状態とは別にタブの文字色を変えたい場合に使用
    let emphasisIndex: Int?
    /// 下線の色
    let underBarColor: UIColor
    /// 各タブの設定
    let cellConfig: UnderBarTabCellConfig
}

/// 各タブの設定
struct UnderBarTabCellConfig {
    /// 非選択時の文字色
    let normalTextColor: UIColor
    /// 選択時の文字色
    let selectedTextColor: UIColor
    /// 強調するタブの文字色
    let emphasisTextColor: UIColor
    ///　非選択時のフォント
    let normalTextFont: UIFont
    /// 選択時のフォント
    let selectedTextFont: UIFont
}
```
