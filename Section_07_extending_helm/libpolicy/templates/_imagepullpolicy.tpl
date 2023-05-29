{{/*
    Change the image pull policy according to the type of env
*/}}
{{- define "libpolicy.imagePullPolicy" -}}
    {{- $environment := default "production" .Values.environment }}
    {{- if not (eq $environment "production") }}
        {{- "IfNotPresent" }}
    {{- else }}
        {{- "Always" }}
    {{- end }}
{{- end }}

