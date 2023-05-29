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


- `helm env HELM_DATA_HOME`

OUTPUT:
```
/home/pat/.local/share/helm

```
- `export HELMDATADIR=/home/pat/.local/share/helm`

- `mkdir -p $HELMDATADIR/starters`
- `mv mywebstarter $HELMDATADIR/starters`


## now to use it:
- `helm create --starter mywebstarter mynewapp`
  - it is going to create app based on our template