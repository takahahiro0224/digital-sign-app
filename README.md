## このアプリについて
借金請求管理・自動催促ツール

## 技術スタック
- Ruby: 2.6.3
- Ruby on Rails: 6.0.1
- mysql: 5.7.19
- Vue.js: 2.6.10
- UIフレームワーク Rails: Materialize, Vue: vue material


## 開発フロー
masterブランチからfeatureブランチを切り、作業する
作業が終わったらレビューし、レビューが終わったらmasterにmergeされる

## 環境構築 (下記コマンドを順番に実行)
dockerとdocker-compose必要 (macならDocker for macを準備)
```bash
git clone https://github.com/takahahiro0224/digital-sign-app.git
```
```bash
docker-compose build
```
```bash
docker-compose up
```
#### bundle install（要求されたら）
```
docker-compose run web bundle install
```
#### DB作成・マイグレーション
```bash
docker-compose run web rails db:create
```
```bash
docker-compose run web rails db:migrate
```
#### フロントエンド(改定中）
ライブラリのインストール
```bash
docker-compose run web yarn install
```
localhost:3000を開いてページが表示されていればok

## 開発中に使うコマンド
#### コンテナ起動状態確認
```bash
docker-compose ps -a
```
#### コンテナ起動
```bash
docker-compose up
```
#### コンテナ停止
```bash
docker-compose stop
```
#### webpack-dev-server起動
```
docker-compose run web bin/webpack-dev-server
```
#### bashプロセスに入る(このプロセス内でrailsコマンドなど行う)
```bash
docker exec -it digital-sign-app_web_1 /bin/bash
```
## トラブルなど
#### 適宜コンテナの再起動、再ビルド、Dockerの再起動を試してみてください
#### コード変更に応じて適宜bundle installしてgemのインストールを行う
#### DB変更した際はマイグレーションを行う
#### その他不明点あれば私まで連絡ください

