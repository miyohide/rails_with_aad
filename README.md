Railsアプリに対してAzure AD認証を追加する

# はじめに

Railsアプリに認証機能を追加する際、[devise](https://github.com/heartcombo/devise)や[sorcery](https://github.com/Sorcery/sorcery)などのgemを使うのがよく使われますが、最近ではIDaaSというサービスがたくさん出ています。これらを使うことでユーザー管理に伴う様々な問題から解放されるということなので、Azure Active Directoryを使ってRailsアプリに認証機能を実装してみることにしました。

# 最初に試したこと

[sorcery](https://github.com/Sorcery/sorcery)のWiki Pageをみていたら、[External Microsoft Graph authentication](https://github.com/Sorcery/sorcery/wiki/External---Microsoft-Graph-authentication)という記事を見つけたのでこれをやってみることにしました。

ただ、Wiki中に

> Finally under Redirect URI add a URI for your app. This is the address Azure will respond to with Authentication info.

と記載があるのですが、私がAzure Portal上で試すと「クエリ文字列を含める事はできない」というエラーメッセージが出て登録できませんでした。

結局、動かすことができずに終了しました。

# マイクロソフトのチュートリアルをやってみる

何かいい手はないものかと思っていたところに、たまたま[マイクロソフトがチュートリアルを公開している](https://docs.microsoft.com/en-us/graph/tutorials/ruby)ことを発見。これに沿って実装してみることにしました。

# いくつか変更

結果的にはこのチュートリアルはうまく動きましたが、いくつか変更が必要な点がありました。また、最近のRailsアプリではよりよい実装方法があるのでそこも対処してみました。

## oauth_environment_variables.rbの作成

[「Add Azure AD authentication」](https://docs.microsoft.com/en-us/graph/tutorials/ruby?tutorial-step=3)の部分にて`oauth_environment_variables.rb`を作成していろいろな値を環境変数経由で格納するところがあるのですが、これは[Railsが持っているcredentialの管理方法](https://railsguides.jp/security.html#%E7%8B%AC%E8%87%AA%E3%81%AEcredential)に従った方が良いかなと思いました。

実際のやり方は[「パーフェクトRuby on Rails【増補改訂版】」](https://gihyo.jp/book/2020/978-4-297-11462-6)に載っているので参照すると良いでしょう。



# OmniAuth::AuthenticityError Forbidden Erros が発生する

see. https://stackoverflow.com/questions/65822440/build-ruby-on-rails-apps-with-microsoft-graph-tutorial-omniauthauthenticityerr

omniauth gemのバージョンを1系に固定化することで対処。

# NameError (undefined local variable or method `token_hash' for ....が発生する

`session[:graph_token_hash]`に格納されているデータ構造が想定と違う？
