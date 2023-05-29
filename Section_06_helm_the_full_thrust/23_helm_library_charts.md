# 23 Library Charts

Recap about `_helpers.tpl`
- it is not rendered by helm
- provide common functionality

[Library charts](https://helm.sh/docs/topics/library_charts/)

A library chart is a type of Helm chart that defines chart primitives or definitions which can be shared by Helm templates in other charts. This allows users to share snippets of code that can be re-used across charts, avoiding repetition and keeping charts DRY.

The library chart was introduced in Helm 3 to formally recognize common or helper charts that have been used by chart maintainers since Helm 2. By including it as a chart type, it provides:

A means to explicitly distinguish between common and application charts
Logic to prevent installation of a common chart
No rendering of templates in a common chart which may contain release artifacts
Allow for dependent charts to use the importer's context

# Process of creating library charts
- `helm create libpolicy`
- `rm -rf templates/*`
- `rm values.yaml`