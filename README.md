# 準備
この記事では、サッカーのトラッキングデータから、サッカーを可聴化する手順を説明します。
このシステムでは、Processingを使用してシステムをつくリます。
この記事では、Windowsでの作業を想定しています。
また、システムの完成のためには、サッカーのトラッキングデータが必要なので、各自用意してください。


## CrestMuseのインストール
Processing上で音を鳴らすためのライブラリをインストールします。
このシステムでは、kitaharalab作成のCrestMuseというライブラリを使用します。

1. 以下のGithubリンクにアクセスしてください。
   
https://github.com/kitaharalab/cmx/releases

2. すべてのファイルをダウンロードしてください。
3. 「ドキュメント」の「Processing」の「libraries」にフォルダ「cmx」を置いてください。

## Meshのインストール
サッカーの描画処理に必要なライブラリをインストールします。
このシステムでは、Lee Byron作成のMeshといライブラリを使用します。
以下のWebサイトにアクセスし、ライブラリをインストールしてください。

https://leebyron.com/mesh/



## プログラムのダウンロード
このページのpdeファイルをすべてダウンロードしてください。

ダウンロードしたpdeファイルを、football_sonificationというディレクトリ直下に全て置いてください。

## データの準備
このシステムでは、データスタジアム株式会社から提供を受けたサッカーのトラッキングデータを使用しています。このデータは有料のものであるため、各自で用意してください。

# 実行
## データを所定された場所に置く
用意したデータを、football_sonificationファイルの58行目で読み込んでください。

## 実行！
![](https://storage.googleapis.com/zenn-user-upload/11cd5fc0f051-20240130.png)
このような描画が行われる動画と音が再生されれば完成です！

