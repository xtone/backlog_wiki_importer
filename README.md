# Importer to backlog wiki

他のドキュメント管理ツールからmarkdown形式でエクスポートされたファイルをbacklogのwikiにインポートするスクリプトです。

## Getting Started

インポートしたい先のbacklogの`project id`と`apiKey`を取得しておきます。
このスクリプトでは環境変数に設定されている`project id`と`apiKey`の値を利用するので、スクリプト実行前に以下の環境変数を設定してください。

### 環境変数

|環境変数名|値|
|----------|--|
|BACKLOG_ENDPOINT|backlogのチーム用ドメインを設定します。***.backlog.jpというフォーマットで指定します|
|BACKLOG_PROJECT_ID|インポートしたい先のbacklogのプロジェクトID (数値)|
|BACKLOG_API_KEY|ユーザー毎に発行可能なbacklogのAPIキー|

```bash
export BACKLOG_ENDPOINT=<backlogのチーム用ドメイン>
export BACKLOG_PROJECT_ID=<backlogのプロジェクトID>
export BACKLOG_API_KEY=<backlogのAPIキー>
```

### スクリプトの実行準備

ruby 2.3以上とbundlerをインストールしてある環境を用意してください。
それ以外の必要なライブラリは`bundle install`で取得します。

```bash
cd $IMPORT_SCRIPT_DIR
bundle install --path vendor/bundle
```

### インポートするmarkdownファイル

ディレクトリ階層がそのままwikinameになります。
例えば`インフラ/ネットワーク/VPN.md`というディレクトリ構造のファイルをインポートすると、
wikiの該当するページの名前は`インフラ/ネットワーク/VPN`になります。
backlog側のwikiの設定で`ツリー表示を有効にする`オプションを有効にしておけば、backlogでもツリー構造を保ったままインポートできます。

また、デフォルトではbacklogのテキスト整形ルールがbacklog用のフォーマットになっているため、markdownファイルをインポートしても表示が意図と異なります。
その場合、backlogの設定でテキスト整形のルールを`Markdown`に変更してください。

インポートは以下のコマンドで実行できます。

```bash
cd $IMPORT_SCRIPT_DIR
bundle exec ruby import.rb -p <Markdownファイルがあるディレクトリ>
```

`import.rb`は以下のコマンドライン引数をサポートします。

|オプション|概要|
|----------|----|
|-p <ディレクトリパス>|Markdownファイルがあるディレクトリを指定します。|
|-d |dry runモードで実行します。実際にインポート処理は行われません。|