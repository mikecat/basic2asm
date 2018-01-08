N88BASICっぽいのをアセンブリ言語に変換するやつ
----------------------------------------------

概要
====

N88BASICっぽいプログラムをx86(IA-32)のアセンブリ言語に変換する。
入出力はC言語のライブラリを利用する。

仕様
====

### コマンドラインインターフェース

```
java -jar Basic2Asm.jar [オプション]
```

オプション一覧

* `-i 入力ファイル名` : 入力ファイルを指定する。指定しない場合は標準入力を用いる。
* `-o 出力ファイル名` : 出力ファイルを指定する。指定しない場合は標準出力を用いる。
* `--underbar on|off` : C言語のライブラリを利用する時、関数名にアンダーバーをつけるかを指定する。指定しない場合はつけない。

### プログラム仕様

#### 値の範囲

このプログラムで扱う「整数」は32ビット符号付き整数(-2147483648～2147483647)とする。
浮動小数点数、分数、複素数などは扱わない。

#### 行の基本形式

```
[行番号] コマンド コマンドに依存する情報
```

行番号はあっても無くてもいいが、用意する場合は0以上の整数とする。

コマンドは`PRINT`などである。

#### コマンド

##### PRINT

```
PRINT 出力する値
```

整数を1個出力し、改行を出力する。
「出力する値」には式が使用可能である。

#### 式

##### プリミティブ

###### 整数

半角の十進アラビア数字で表す。

##### 演算子

###### +

両辺の数の和を計算する。
