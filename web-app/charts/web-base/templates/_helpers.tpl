{{/*
Expand the name of the chart.
*/}}
{{- define "web-base.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "web-base.fullname" -}}
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
{{- define "web-base.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create namespace .
*/}}
{{- define "web-base.namespace" -}}
{{- printf "%s" .Release.Namespace }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "web-base.labels" -}}
helm.sh/chart: {{ include "web-base.chart" . }}
{{ include "web-base.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "web-base.selectorLabels" -}}
app.kubernetes.io/name: {{ include "web-base.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "web-base.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "web-base.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
  Create images of web-base events
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
  Return web-base events app name
*/}}
{{- define "web-base.get-events-name " -}}
  {{- print (include "web-base.fullname") "-events" -}}
{{- end -}}

{{/*
  Return web-base landingpage app name
*/}}
{{- define "web-base.get-landingpage-name " -}}
  {{- print (include "web-base.fullname") "-landingpage" -}}
{{- end -}}
