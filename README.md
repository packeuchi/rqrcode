# RQRCode

Sorry Japanese language only!

[takeuchi-c-flat/rqrcode](https://github.com/takeuchi-c-flat/rqrcode) この ForkedRepository は、日本の医療業界で使われている院外処方箋などの連結QRCODEの、Ruby環境からの出力をサポートする為に機能拡張を行っています。


[RQRCode](https://github.com/whomwah/rqrcode) is a library for creating and rendering QR codes into various formats. It has a simple interface with all the standard QR code options. It was adapted from the Javascript library by Kazuhiko Arase.

* QR code is trademarked by Denso Wave inc
* Minimum Ruby version is `~> 2.3`
* For `rqrcode` releases `< 1.0.0` please use [this README](https://github.com/whomwah/rqrcode/blob/cd2732a68434e6197c219e6c8cbdadfce0c4c4f3/README.md)

## Installing

Add this line to your application's `Gemfile`:

```ruby
gem 'rqrcode_core', :git => 'git://github.com/takeuchi-c-flat/rqrcode_core.git'
gem 'rqrcode', :git => 'git://github.com/takeuchi-c-flat/rqrcode.git'
```

## Basic usage example

ここでは、日本の医療業界で使われる院外処方箋に印刷する連結QRCODEを出力するサンプルを示します。

QRCODEに収めるデータは以下のような形式になります。
  * データ形式 : CSV
  * 文字コード : ShiftJIS
  * 改行 : CR(0x0D) + LF(0x0A)
  * 末尾にEOF(0x1A)を付加
  * CSVファイルを丸ごとバイナリ形式でQRCODEで表現するイメージです。

```ruby
require 'rqrcode'

# 改行・EOFを含んだShiftJIS形式の文字列データ
sjis_text = '...................' 

# QRCODEを複数生成
qrcode_list = RQRCode::ConnectedQRUtil.generate_binary_connected_qrcodes(
  sjis_text, size: 10, level: :l, adjust_for_sjis: true)

# PNGファイルに変換して、filepath のListを返す。
qrcode_list.map { |qrcode|
  filepath = File.join('tmp/qrcode', SecureRandom.uuid)
  qrcode.as_png(module_px_size: 2, file: filepath)
  filepath
}
```

### Advanced Options

These are the various QR Code generation options provided by [c-flat-takeuchi/rqrqcode_core](https://github.com/c-flat-takeuchi/rqrcode_core).

```
string - the string you wish to encode

size   - the size of the qrcode (1-40 default 4)

level  - the error correction level, can be:
  * Level :l 7%  of code can be restored
  * Level :m 15% of code can be restored
  * Level :q 25% of code can be restored
  * Level :h 30% of code can be restored (default :h)
```

### More Information

* 院外処方箋のQRCODEの規格は、関係団体によって定めた基準がありますので、そちらに準拠して下さい。

* 本Gemで作成する分割QRCODEは、バイナリモードのみをサポートしています。
* QRコードは最大で16個にまで分割できます。
  * 分割QRコードの規格上の上限です。
  * 個数を超過した場合の動作は保証されません。
* `generate_binary_connected_qrcodes` メソッドにおける `adjust_for_sjis:` パラメタを使用すると、ShiftJISの全角文字列が2つのQRCODEに跨って格納される事がないようにします。
  * 医療機関で使用するレーザースキャナなどは、対策をしなくとも特に問題なく読み取れると思われますが、QRコードリーダーアプリの中には文字化けを起こすものがあります。
  * 動作確認等に影響が出ないよう、安全側に倒す事ができます。

## Original API Documentation

[http://www.rubydoc.info/gems/rqrcode](http://www.rubydoc.info/gems/rqrcode)

## Original Repository

* [https://github.com/whomwah/rqrcode]
* [https://github.com/whomwah/rqrcode_core]
* Thanks for Mr.Duncan Roberson.

## Authors

Original RQRCode author: Duncan Robertson

A massive thanks to [all the contributors of the library over the years](https://github.com/whomwah/rqrcode/graphs/contributors). It wouldn't exist if it wasn't for you all.

Oh, and thanks to my bosses at https://kyan.com for giving me time to maintain this project.

## Resources

* wikipedia:: http://en.wikipedia.org/wiki/QR_Code
* Denso-Wave website:: http://www.denso-wave.com/qrcode/index-e.html
* kaywa:: http://qrcode.kaywa.com

## Copyright

MIT License (http://www.opensource.org/licenses/mit-license.html)
