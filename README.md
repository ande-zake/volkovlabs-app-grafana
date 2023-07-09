
# Important Notes
## Errors & Solutions
Error : 
The docker image start failure with the error "grafana  | logger=provisioning t=2023-06-29T15:15:13.822709292Z level=error msg="Failed to provision plugins" error="app provisioning error: plugin not installed: \"volkovlabs-app\""
grafana  | Error: ✗ app provisioning error: plugin not installed: "volkovlabs-app", how can i fix this.
Solutions : 
That's expected, Volkov Labs App is a part of the docker image we use for our projects. You can (select one of these below)
1) Build `volkovlabs-app` plugin (`npm install` and `npm run build`) if you are interested to create your own application plugin
2) Remove copy provisioning files (line 37) and `dist` plugin folder (line 33) from the Dockerfile.

# Volkov Labs App for Grafana
![App](https://raw.githubusercontent.com/volkovlabs/volkovlabs-app/main/img/app.png)

![Grafana 10](https://img.shields.io/badge/Grafana-10.0.0-orange)
[![YouTube](https://img.shields.io/badge/YouTube-Channel-red)](https://youtube.com/@volkovlabs)
![CI](https://github.com/volkovlabs/volkovlabs-app/workflows/CI/badge.svg)
![E2E](https://github.com/volkovlabs/volkovlabs-app/workflows/E2E/badge.svg)
[![codecov](https://codecov.io/gh/VolkovLabs/volkovlabs-app/branch/main/graph/badge.svg)](https://codecov.io/gh/VolkovLabs/volkovlabs-app)
[![CodeQL](https://github.com/VolkovLabs/volkovlabs-app/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/VolkovLabs/volkovlabs-app/actions/workflows/codeql-analysis.yml)

## Introduction

The Volkov Labs App includes a Docker image with customized Grafana and an App plugin with information about Volkov Labs maintained plugins.

## Customization

Months of work bundled with deep expertise nicely wrapped into a 7-minute long video revealing simple steps to customize Grafana. In this tutorial, we answered all community questions we collected to this moment.

[![Customization](https://raw.githubusercontent.com/volkovlabs/volkovlabs-app/main/img/customize.png)](https://youtu.be/ChI78v4UZc0)

## Docker image

We use custom build Docker image for all our projects and keep it up-to-date with the latest version of Grafana.

```sh
docker pull ghcr.io/volkovlabs/app:latest
```

## Bundle

App plugin includes:

- [RSS/Atom data source](https://volkovlabs.io/plugins/volkovlabs-rss-datasource)
- [Dynamic text panel](https://volkovlabs.io/plugins/volkovlabs-dynamictext-panel)

## Support

- Subscribe to our [YouTube Channel](https://www.youtube.com/@volkovlabs) and add a comment.
- Premium support for the development plugins is available via [GitHub Sponsor](https://github.com/sponsors/VolkovLabs).

## License

Apache License Version 2.0, see [LICENSE](https://github.com/volkovlabs/volkovlabs-app/blob/main/LICENSE).
