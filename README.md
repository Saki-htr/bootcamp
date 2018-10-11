# Bootcamp

プログラマー向けEラーニングシステム。

## インストール

    $ brew install yarn
    $ bin/setup
    $ yarn install
    $ rails s

You can also launch a web server with [rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler).

    $ RACK_PROFILER=1 rails s

## テスト

Test with headless browser.

```
$ ./bin/test
```

Test with real browser.

```
$ HEADED=1 ./bin/test
```

## Lint

rubocopとslim-lintを実行します。

```
$ ./bin/lint
```
