---
apiVersion: v1
kind: Secret
metadata:
  name: synlig-PIPELINE_TYPE-pipeline
  labels:
    github.synlig/commit-sha: COMMIT_SHA
    app.kubernetes.io/name: synlig
    app.kubernetes.io/component: logstash-pipeline
    app.kubernetes.io/managed-by: synlig-iac
stringData:
  pipelines.yml: |-
    - pipeline.id: main
      config.string: |
        PIPELINE_CONFIG

...