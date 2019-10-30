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
```
let view = UnderBarTabView()
view.underBarColor = .red                              // 下線の色
UnderBarTabCell.normalFont = .systemFont(ofSize: 15)   // タブ非選択時のフォント
UnderBarTabCell.selectedFont = .systemFont(ofSize: 16) // タブ選択時のフォント
UnderBarTabCell.normalTextColor = .black               // タブ非選択時の文字色
UnderBarTabCell.selectedTextColor = .red               // タブ選択時の文字色
```
