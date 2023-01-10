{{/*
Expand the name of the chart.
*/}}
{{- define "quickom-me.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "quickom-me.fullname" -}}
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
{{- define "quickom-me.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create namespace .
*/}}
{{- define "quickom-me.namespace" -}}
{{- printf "%s" .Release.Namespace }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "quickom-me.labels" -}}
helm.sh/chart: {{ include "quickom-me.chart" . }}
{{ include "quickom-me.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "quickom-me.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quickom-me.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "quickom-me.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "quickom-me.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
  Create images of quickom-me events
*/}}
{{- define "utils.get-image" -}}
{{- if .image }}
  {{- if .image.sha }}
    {{- printf "%s:%s@sha256:%s"  .image.repository .image.tag  .image.sha }}
  {{- else }}
    {{- printf "%s:%s"  .image.repository  .image.tag }} 
  {{- end -}}
{{- else -}}
{{- fail "Quickok-me Events image is required" -}}
{{- end -}}
{{- end -}}
{{/*
   Get resources: limits, request
*/}}
{{- define "utils.get-resources" -}}
  {{- if .resources -}}
  {{- toYaml . -}}
  {{- else -}}
requests:
  memory: "60Mi"
  cpu: "50m"
limits:
  memory: "100Mi"
  cpu: "80m"
  {{- end -}}
{{- end -}}

{{/*
  Return quickom-me events app name
*/}}
{{- define "quickom-me.get-events-name " -}}
  {{- print (include "quickom-me.fullname") "-events" -}}
{{- end -}}

{{/*
  Return quickom-me landingpage app name
*/}}
{{- define "quickom-me.get-landingpage-name " -}}
  {{- print (include "quickom-me.fullname") "-landingpage" -}}
{{- end -}}
