{{/*
Expand the name of the chart.
*/}}
{{- define "managed-web-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "managed-web-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "managed-web-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "managed-web-app.labels" -}}
helm.sh/chart: {{ include "managed-web-app.chart" . }}
{{ include "managed-web-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "managed-web-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "managed-web-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "managed-web-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "managed-web-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Retrieve secret name from context
*/}}
{{- define "managed-web-app.secretName" -}}
{{- if .existingSecret  -}}
{{- print .existingSecret -}}
{{- else -}}
{{- print ( include "managed-web-app.fullname" . )  -}}
{{- end -}}
{{- end -}}




{{/*
Retrieve tls secret name from context
Params (one of ):
    - existingSecret:
    - certificateSecret:
*/}}
{{- define "managed-web-app.tlsSecretName" -}}
{{- $secretName := coalesce .existingSecret  .certificateSecret -}}
{{- if $secretName -}}
    {{- printf "%s" $secretName -}}
{{- else -}}
    {{- printf "%s-crt" (include "managed-web-app.fullname" . ) -}}
{{- end -}}
{{- end -}}


{{/*
Redis config map name
*/}}
{{- define "managed-web-app.redis.configmapName" -}}
{{- if .Values.redis.config.configMapName -}}
    {{- printf "%s" .Values.redis.config.configMapName -}}
{{- else -}}
    {{- printf "%s-redis-config" ( include "managed-web-app.name" $ ) -}}
{{- end -}}
{{- end -}}