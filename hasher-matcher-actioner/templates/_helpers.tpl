{{/*
Expand the name of the chart.
*/}}
{{- define "hasher-matcher-actioner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hasher-matcher-actioner.fullname" -}}
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
{{- define "hasher-matcher-actioner.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hasher-matcher-actioner.labels" -}}
helm.sh/chart: {{ include "hasher-matcher-actioner.chart" . }}
{{ include "hasher-matcher-actioner.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hasher-matcher-actioner.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hasher-matcher-actioner.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hasher-matcher-actioner.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hasher-matcher-actioner.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the database environment variables
*/}}
{{- define "hasher-matcher-actioner.databaseEnv" -}}
- name: POSTGRES_HOST
  value: "{{ .Values.database.host }}"
- name: POSTGRES_PORT
  value: "{{ .Values.database.port }}"
- name: POSTGRES_DB
  value: "{{ .Values.database.name }}"
- name: POSTGRES_USER
  value: "{{ .Values.database.user }}"
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secret.name }}
      key: postgres-password
{{- end }}
