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

なお、この変更で値の参照方法も`ENV['AZURE_APP_ID']`のように環境変数を参照する形から`Rails.application.credentials.azure_app_id`のように変更する必要があります。

## scopeの範囲

チュートリアルでは`ENV['AZURE_SCOPES']`に`openid profile email offline_access user.read mailboxsettings.read calendars.readwrite`を指定していましたが、私が試した時はうまく動きませんでした。おそらく試したユーザーの設定方法に依存するかと思います。私の場合、`email`、`mailboxsettings.read`、`calendars.readwrite`の内容を消すと動かすことができました。

合わせて`microsoft_graph_auth.rb`の`raw_info`メソッドにおいて`/me`エンドポイントへのクエリ文字列からも`mail`と`mailboxSettings`を削除しましたが、これがどう影響したかは調べきれていないです。

## OmniAuth::AuthenticityError Forbidden Erros が発生する

一番ハマったのが`OmniAuth::AuthenticityError Forbidden Erros`が発生する問題です。色々と検索したところ、以下のstackoverflowの記事が該当しました。

[Build Ruby on Rails apps with Microsoft Graph Tutorial OmniAuth::AuthenticityError Forbidden Erros](https://stackoverflow.com/questions/65822440/build-ruby-on-rails-apps-with-microsoft-graph-tutorial-omniauthauthenticityerr)

omniauth gemのバージョンを1系に固定化することで対応可能ということなので、`Gemfile`に`gem 'omniauth', '~> 1'`を1行追加して`bundle update`を実行しました。

これで、「Add Azure AD authentication」の最後まで動作しました。

# ユーザーの取得を行う

チュートリアルではカレンダーデータの取得を行なっていましたが、自分は[Microsoft Graph APIのユーザーの取得](https://docs.microsoft.com/ja-jp/graph/api/user-get?view=graph-rest-1.0&tabs=http)を発行してみることにしました。

チュートリアルでは、`app/helpers/graph_helper.rb`を作成していますが、ヘルパーはViewのために書くものなので、ちょっと違和感があります。私は、`lib`以下に作成し、`make_api_call`メソッドの定義を以下のようにしました（`self.`を追加した）。

```ruby
def self.make_api_call(method, endpoint, token, headers = nil, params = nil, payload = nil)
```

このメソッドをcontrollerで

```ruby
::GraphHelper.make_api_call("GET", "/v1.0/me", access_token)
```

という形で呼び出してあげると、Graph APIの呼び出しが成功します。
