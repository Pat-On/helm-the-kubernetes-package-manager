# 17 The conditional statements

- We can use if statements in the helm to dynamically decide if we want to deploy the specific resources or set-up some values

Example from the serviceacccount.yaml file
```
{{- if .Values.serviceAccount.create -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "myapp.serviceAccountName" . }}
  labels:
    {{- include "myapp.labels" . | nindent 4 }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
```

- important about the Go(?) syntax - you need to have an end statement


`{{- if .Values.serviceAccount.create -}}` and in `{{- end }}`
pay attention to the `-` because we are removing the white spaces from the templates

  - `eq` EQUAL
  - `ne` NOT EQUAL
  - `gt` greater than
  - `lt`
  - `ge`
  - `le`
  - `and`
  - `or`
  - `not`
  - `fail` - to intentionally abort chart execution and provide an error message


## Examples of syntax:

- `{{- if and (eq .Values.service.type "ClusterIP") .Values.ingress.enabled -}}`

- `{{- if or (eq .Values.service.type "ClusterIP") .Values.ingress.enabled -}}`

```
{{- if not .Values.important -}}
{{- fail "Please provide the important value" -}}
{{- end }}
```

## fail is commonly used to validate k8s engine and check it version if it is compatible  

```
{{- if lt (.Capabilities.KubeVersion.Minor | int) 23 -}}
{{- fail "This chart requires K8s version 1.23 or higher" -}}
{{- end }}
```