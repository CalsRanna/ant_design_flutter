<p align="center">
  <a href="https://ant.design">
    <img width="200" src="https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg">
  </a>
</p>

<h1 align="center">Ant Design Flutter</h1>

<div align="center">

An enterprise-class UI design language and Flutter UI library.

![Pub Version](https://img.shields.io/pub/v/ant_design_flutter?style=for-the-badge) ![GitHub](https://img.shields.io/github/license/CalsRanna/ant_design_flutter?style=for-the-badge)

[npm-image]: http://img.shields.io/npm/v/antd.svg?style=flat-square
[npm-url]: http://npmjs.org/package/antd
[github-action-image]: https://github.com/ant-design/ant-design/workflows/%E2%9C%85%20test/badge.svg
[github-action-url]: https://github.com/ant-design/ant-design/actions?query=workflow%3A%22%E2%9C%85+test%22
[codecov-image]: https://img.shields.io/codecov/c/github/ant-design/ant-design/master.svg?style=flat-square
[codecov-url]: https://codecov.io/gh/ant-design/ant-design/branch/master
[download-image]: https://img.shields.io/npm/dm/antd.svg?style=flat-square
[download-url]: https://npmjs.org/package/antd
[lgtm-image]: https://flat.badgen.net/lgtm/alerts/g/ant-design/ant-design
[lgtm-url]: https://lgtm.com/projects/g/ant-design/ant-design/alerts/
[fossa-image]: https://app.fossa.io/api/projects/git%2Bgithub.com%2Fant-design%2Fant-design.svg?type=shield
[fossa-url]: https://app.fossa.io/projects/git%2Bgithub.com%2Fant-design%2Fant-design?ref=badge_shield
[help-wanted-image]: https://flat.badgen.net/github/label-issues/ant-design/ant-design/help%20wanted/open
[help-wanted-url]: https://github.com/ant-design/ant-design/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22
[twitter-image]: https://img.shields.io/twitter/follow/AntDesignUI.svg?label=Ant%20Design%20Flutter&style=social
[twitter-url]: https://twitter.com/AntDesignUI
[discussions-image]: https://img.shields.io/badge/discussions-on%20github-blue?style=flat-square
[discussions-url]: https://github.com/ant-design/ant-design/discussions
[bundlesize-js-image]: https://img.badgesize.io/https:/unpkg.com/antd/dist/antd.min.js?label=antd.min.js&compression=gzip&style=flat-square
[bundlesize-css-image]: https://img.badgesize.io/https:/unpkg.com/antd/dist/antd.min.css?label=antd.min.css&compression=gzip&style=flat-square
[unpkg-js-url]: https://unpkg.com/browse/antd/dist/antd.min.js
[unpkg-css-url]: https://unpkg.com/browse/antd/dist/antd.min.css
[issues-helper-image]: https://img.shields.io/badge/using-issues--helper-orange?style=flat-square
[issues-helper-url]: https://github.com/actions-cool/issues-helper
[renovate-image]: https://img.shields.io/badge/renovate-enabled-brightgreen.svg?style=flat-square
[renovate-dashboard-url]: https://github.com/ant-design/ant-design/issues/32498

</div>

[![](https://gw.alipayobjects.com/mdn/rms_08e378/afts/img/A*Yl83RJhUE7kAAAAAAAAAAABkARQnAQ)](https://ant.design)

English | [Português](./README-pt_BR.md) | [简体中文](./README-zh_CN.md) | [Українською](./README-uk_UA.md) | [Spanish](./README-sp_MX.md)

## ✨ Features

- 🌈 Enterprise-class UI designed for web applications.
- 📦 A set of high-quality Flutter components out of the box.
- 🛡 Written in pure Dart with null safety.
- ⚙️ Whole package of design resources and development tools.
- 🌍 Internationalization support for dozens of languages.
- 🎨 Powerful theme customization in every detail.

## 🖥 Environment Support

- Working on Windows and Mac Os

## 📦 Install

```bash
flutter pub add ant_design_flutter
```

## 🔨 Usage

```dart
import 'package:ant_design_flutter/antdf.dart';

void main() {
  runApp(const AntApp(
    home: AntScaffold(
      body: Center(
        child: Button(
          type: ButtonType.primary,
          child: Text("Press Me"),
        ),
      )
    ),
  ));
}
```

### Null Safety

`antdf` is written in dart with null safety, check [Sound Null Safety](https://flutter.cn/posts/announcing-dart-2-12#%E5%81%A5%E5%85%A8%E7%9A%84%E7%A9%BA%E5%AE%89%E5%85%A8) to get started.

## 🌍 Internationalization

Dozens of languages supported in `antdf`, see [i18n](https://ant.design/docs/react/i18n).

## 🔗 Links

- [Home page](https://ant.design/)
- [Components Overview](https://ant.design/components/overview)
- [Ant Design Pro](http://pro.ant.design/)
- [Change Log](CHANGELOG.en-US.md)
- [rc-components](http://react-component.github.io/)
- [Mobile UI](http://mobile.ant.design)
- [Ant Design Pro Components](https://procomponents.ant.design)
- [Ant Design Charts](https://charts.ant.design)
- [Ant Design Icons](https://github.com/ant-design/ant-design-icons)
- [Ant Design Colors](https://github.com/ant-design/ant-design-colors)
- [Landing Pages](https://landing.ant.design)
- [Motion](https://motion.ant.design)
- [Scaffold Market](http://scaffold.ant.design)
- [Developer Instruction](https://github.com/ant-design/ant-design/wiki/Development)
- [Versioning Release Note](https://github.com/ant-design/ant-design/wiki/%E8%BD%AE%E5%80%BC%E8%A7%84%E5%88%99%E5%92%8C%E7%89%88%E6%9C%AC%E5%8F%91%E5%B8%83%E6%B5%81%E7%A8%8B)
- [FAQ](https://ant.design/docs/react/faq)
- [CodeSandbox Template](https://u.ant.design/codesandbox-repro) for bug reports
- [Customize Theme](https://ant.design/docs/react/customize-theme)
- [How to Apply for Being A Collaborator](https://github.com/ant-design/ant-design/wiki/Collaborators#how-to-apply-for-being-a-collaborator)

## ⌨️ Development

Use Gitpod, a free online dev environment for GitHub.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ant-design/ant-design)

Or clone locally:

```bash
$ git git@github.com:CalsRanna/ant_design_flutter.git
$ cd ant_design_flutter
$ flutter install
$ flutter run
```

Now flutter will choose the device avaiale in your environment, see more at [Development](https://github.com/ant-design/ant-design/wiki/Development).

## 🤝 Contributing [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Read our [contributing guide](https://ant.design/docs/react/contributing) and let's build a better antd together.

We welcome all contributions. Please read our [CONTRIBUTING.md](https://github.com/ant-design/ant-design/blob/master/.github/CONTRIBUTING.md) first. You can submit any ideas as [pull requests](https://github.com/ant-design/ant-design/pulls) or as [GitHub issues](https://github.com/ant-design/ant-design/issues). If you'd like to improve code, check out the [Development Instructions](https://github.com/ant-design/ant-design/wiki/Development) and have a good time! :)

If you are a collaborator, please follow our [Pull Request principle](https://github.com/ant-design/ant-design/wiki/PR-principle) to create a Pull Request with [collaborator template](https://github.com/ant-design/ant-design/compare?expand=1&template=collaborator.md).

[![Let's fund issues in this repository](https://issuehunt.io/static/embed/issuehunt-button-v1.svg)](https://issuehunt.io/repos/34526884)

## ❤️ Sponsors and Backers
