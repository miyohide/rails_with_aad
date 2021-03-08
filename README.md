Railsアプリに対してAzure AD認証を追加する

# はじめに

Railsアプリに認証機能を追加する際、[devise](https://github.com/heartcombo/devise)や[sorcery](https://github.com/Sorcery/sorcery)などのgemを使うのがよく使われますが、最近ではIDaaSというサービスがたくさん出ています。これらを使うことでユーザー管理に伴う様々な問題から解放されるということなので、Azure Active Directoryを使ってRailsアプリに認証機能を実装してみることにしました。

# 最初に試したこと




# これは何か

Railsアプリに対してAzure AD認証を追加するテストです。

最初は以下の記事を参照して実装。

https://github.com/Sorcery/sorcery/wiki/External---Microsoft-Graph-authentication

Redirect URLに以下のURLを指定しろと書いているが、Azure Portal上では設定できなかった（クエリ文字列を含める事はできない）。

```
http://localhost:3000/oauth/callback?provider=microsoft
```

# OmniAuth::AuthenticityError Forbidden Erros が発生する

see. https://stackoverflow.com/questions/65822440/build-ruby-on-rails-apps-with-microsoft-graph-tutorial-omniauthauthenticityerr

omniauth gemのバージョンを1系に固定化することで対処。

# NameError (undefined local variable or method `token_hash' for ....が発生する

`session[:graph_token_hash]`に格納されているデータ構造が想定と違う？
