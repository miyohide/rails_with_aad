# これは何か

Railsアプリに対してAzure AD認証を追加するテストです。

最初は以下の記事を参照して実装。

https://github.com/Sorcery/sorcery/wiki/External---Microsoft-Graph-authentication

Redirect URLに以下のURLを指定しろと書いているが、Azure Portal上では設定できなかった（クエリ文字列を含める事はできない）。

```
http://localhost:3000/oauth/callback?provider=microsoft
```
