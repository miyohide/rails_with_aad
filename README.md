Railsアプリに対してAzure AD認証を追加する

# はじめに

Railsアプリに認証機能を追加する際、[devise](https://github.com/heartcombo/devise)や[sorcery](https://github.com/Sorcery/sorcery)などのgemを使うのがよく使われますが、最近ではIDaaSというサービスがたくさん出ています。これらを使うことでユーザー管理に伴う様々な問題から解放されるということなので、Azure Active Directoryを使ってRailsアプリに認証機能を実装してみることにしました。

# 最初に試したこと

[sorcery](https://github.com/Sorcery/sorcery)のWiki Pageをみていたら、[External Microsoft Graph authentication](https://github.com/Sorcery/sorcery/wiki/External---Microsoft-Graph-authentication)という記事を見つけたのでこれをやってみることにしました。

ただ、Wiki中に

> Finally under Redirect URI add a URI for your app. This is the address Azure will respond to with Authentication info.

と記載があるのですが、私がAzure Portal上で試すと「クエリ文字列を含める事はできない」というエラーメッセージが出て登録できませんでした。

結局、動かすことができずに終了しました。



# OmniAuth::AuthenticityError Forbidden Erros が発生する

see. https://stackoverflow.com/questions/65822440/build-ruby-on-rails-apps-with-microsoft-graph-tutorial-omniauthauthenticityerr

omniauth gemのバージョンを1系に固定化することで対処。

# NameError (undefined local variable or method `token_hash' for ....が発生する

`session[:graph_token_hash]`に格納されているデータ構造が想定と違う？
