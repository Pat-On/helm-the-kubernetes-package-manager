# 15 toYaml, indent, nindent, and the dash

Language used in the helm
https://pkg.go.dev/text/template

The Sprig library provides over 70 template functions for Go’s template language.
https://masterminds.github.io/sprig/



## after modification in the NOTES.txt files:

```
Resources:
{{ .Values.resources }}
```

```
NOTES:
Resources:
map[limits:map[cpu:100m memory:128Mi] requests:map[cpu:100m memory:128Mi]]
```

- any values passed to helm it is proccessed by go and go does not know nothing about yaml
- so that is why it is returning map in the first go because go know only about itself types


## after second modification

```
Resources:
{{ toYaml .Values.resources }}
```

```
NOTES:
Resources:
limits:
  cpu: 100m
  memory: 128Mi
requests:
  cpu: 100m
  memory: 128Mi

```

## after the third modification - adding two spaces 
```
Resources:
  {{ toYaml .Values.resources }}
```
Output:
```
NOTES:
Resources:
  limits:
  cpu: 100m
  memory: 128Mi
requests:
  cpu: 100m
  memory: 128Mi

```
- not exactly what we wanted. because indent does not change anything


## after the fourth modification - indent function + pipping

```
Resources:
  {{ toYaml .Values.resources | indent 2 }}
```

```
NOTES:
Resources:
    limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

# dash command - `-` at the beginning

```
Resources:
  {{- toYaml .Values.resources | indent 2 }}
```

```
NOTES:
Resources:  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

# nindent

- this function adding white spaces bit as well new line
```
Resources:
  {{- toYaml .Values.resources | nindent 2 }}
```

```
NOTES:
Resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

```

# Final note:
- the yaml file can come as well from the command line and would work equally good.


`helm install test --dry-run --set resources.limits.cpu="120m"`

```
NOTES:
Resources:
  limits:
    cpu: 190m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi
```


