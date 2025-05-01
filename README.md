Neste repo criei um módulo Terraform que:
1. Provisiona um S3 bucket para logs com versionamento, encryption SSE-KMS e política que só aceite TLS 1.2.
2. Anexa a um CloudTrail.
3. Exporta nome e ARN em outputs.tf.
