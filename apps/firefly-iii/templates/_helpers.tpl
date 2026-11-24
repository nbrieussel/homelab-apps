{{/* Public hostname of this instance: <hostPrefix><hostSuffix>.<domain>. */}}
{{- define "firefly.host" -}}
{{ printf "%s%s.%s" .Values.hostPrefix .Values.hostSuffix .Values.domain }}
{{- end }}

{{/*
Name of the Service in front of Firefly, same naming rule as the upstream
chart's fullname helper: the release name if it already contains the chart
name (the real instance, release `firefly-iii`), else <release>-firefly-iii
(previews, release `firefly-pr-<N>`).
*/}}
{{- define "firefly.service" -}}
{{ if contains "firefly-iii" .Release.Name }}{{ .Release.Name }}{{ else }}{{ .Release.Name }}-firefly-iii{{ end }}
{{- end }}
