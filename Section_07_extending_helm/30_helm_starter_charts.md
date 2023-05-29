# Helm starter charts

## boilerplate chart

- helm create mywebstarter


```
.
├── charts
├── Chart.yaml
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── NOTES.txt
│   ├── serviceaccount.yaml
│   ├── service.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml

```


## Starter chart
- `find . -type f -exec sed -i 's/mywebserverstarter/<CHARTNAME>/g' {} \;`