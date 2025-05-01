# Desafio 1:

“Logging Bucket Express” – crie um módulo Terraform que:
1. Provisione um S3 bucket para logs com versionamento, encryption SSE-KMS e política que só aceite TLS 1.2.
2. Anexe‐o a um CloudTrail existente (var.cloudtrail_id).
3. Exporte nome e ARN em outputs.tf.

