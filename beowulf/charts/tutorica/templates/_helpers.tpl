{{/*
Expand the name of the chart.
*/}}
{{- define "tutorica.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tutorica.fullname" -}}
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
{{- define "tutorica.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tutorica.labels" -}}
helm.sh/chart: {{ include "tutorica.chart" . }}
{{ include "tutorica.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tutorica.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tutorica.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tutorica.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tutorica.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Retrieve secret name from context
*/}}
{{- define "tutorica.secretName" -}}
{{- if .existingSecret  -}}
{{- print .existingSecret -}}
{{- else -}}
{{- print ( include "tutorica.fullname" . )  -}}
{{- end -}}
{{- end -}}




{{/*
Retrieve tls secret name from context
Params (one of ):
    - existingSecret:
    - certificateSecret:
*/}}
{{- define "tutorica.tlsSecretName" -}}
{{- $secretName := coalesce .existingSecret  .certificateSecret -}}
{{- if $secretName -}}
    {{- printf "%s" $secretName -}}
{{- else -}}
    {{- printf "%s-crt" (include "tutorica.fullname" . ) -}}
{{- end -}}
{{- end -}}


{{/*
Redis config map name
*/}}
{{- define "tutorica.redis.configmapName" -}}
{{- if .Values.redis.config.configMapName -}}
    {{- printf "%s" .Values.redis.config.configMapName -}}
{{- else -}}
    {{- printf "%s-redis-config" ( include "tutorica.name" $ ) -}}
{{- end -}}
{{- end -}}