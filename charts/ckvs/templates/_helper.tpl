{{/*
* Return the RUNNING K8s version as Mj.Mn
*/}}
{{- define "k8sver.major.minor" -}}
{{- $mj := .Capabilities.KubeVersion.Major | trimAll "+" | default "1" -}}
{{- $mn := .Capabilities.KubeVersion.Minor | trimAll "+" | default "24" -}}
{{- printf "%s.%s" $mj $mn -}}
{{- end -}}

{{/*
* return version range
* backward compatibility: N-7
* forward compatibility: N+3 (best efforts w/ deprecation API declaration and CSF components forward compatibility )
*/}}
{{- define "compatibilityKubernetesVersionRange" -}}
{{- $version := semver .Values.qualifiedKubernetesVersion }}
{{- $bwMinor := sub $version.Minor 7 }}
{{- $fwMinor := add $version.Minor 3 }}
{{- printf "%d.%d - %d.%d" $version.Major $bwMinor $version.Major $fwMinor }}
{{- end -}}

{{/*
* Return version valid or not
*/}}
{{- define "isKubernetesVersionValid" -}}
{{- if semverCompare (include "compatibilityKubernetesVersionRange" .) (include "k8sver.major.minor" .) }}
  true
{{- end }}
{{- end -}}

{{/*
* Dump msg with variable
*/}}
{{- define "failVarDump" -}}
{{- . | mustToPrettyJson | printf "\n%s" | fail }}
{{- end -}}
