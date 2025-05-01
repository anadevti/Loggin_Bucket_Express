## 📌 Contexto Geral do Lab "Logging Bucket Express"

Este laboratório serve para demonstrar na prática a criação e configuração automatizada de um bucket S3 da AWS especialmente preparado para armazenar logs de auditoria do CloudTrail de forma segura e padronizada, seguindo as melhores práticas recomendadas.

O CloudTrail é um serviço da AWS que registra automaticamente eventos (logins, criação/modificação de recursos, chamadas de APIs etc.) que ocorrem na sua conta AWS. Esses logs são vitais para segurança, auditoria e conformidade.

---

## 🎯 Qual o Objetivo Específico do Lab?

O objetivo é automatizar via Terraform a criação de uma infraestrutura mínima de segurança para logging e auditoria com as seguintes características essenciais:

- **Bucket S3:**  
  Armazenamento seguro e persistente dos logs gerados pelo CloudTrail.

- **Versionamento:**  
  Garante que cada versão dos logs seja preservada, protegendo contra modificações acidentais ou maliciosas.

- **Criptografia SSE-KMS:**  
  Protege os logs com criptografia avançada gerenciada pela AWS, garantindo segurança adicional.

- **Política que exige apenas conexões TLS 1.2:**  
  Impede acessos inseguros (sem criptografia adequada) ao bucket, aumentando a segurança dos dados armazenados.

- **Integração direta com CloudTrail existente:**  
  Vincula automaticamente o bucket criado ao CloudTrail já provisionado previamente, garantindo uma captura imediata e consistente dos logs.

---

## 🚩 Por que isso é importante em cenários reais?

### 1. **Auditoria e Compliance**
- Em ambientes corporativos, é crucial armazenar logs de maneira segura e duradoura para auditoria e conformidade (ex.: LGPD, GDPR, PCI-DSS).  
- Os logs do CloudTrail armazenados no S3 permitem rastreabilidade completa de quem fez o quê, quando, e onde.

### 2. **Segurança**
- Criptografia e obrigatoriedade de TLS ajudam a mitigar riscos de vazamento e acesso indevido aos logs.
- A utilização de KMS oferece controle granular de chaves de criptografia.

### 3. **Resiliência**
- Versionamento garante recuperação rápida em caso de exclusão ou alteração acidental dos logs.

### 4. **Padronização e Automação (Infra as Code - IaC)**
- Automatizar via Terraform garante a repetibilidade, padronização e facilita auditorias internas.
- Torna simples replicar essa configuração em outras contas ou regiões da AWS.

---

## 📝 Como isso é aplicado num cenário real?

Imagine que você trabalha em uma empresa que precisa garantir conformidade com normas de segurança e privacidade. Ao criar automaticamente um bucket com as configurações mencionadas, você:

- Reduz o esforço operacional de configuração manual.
- Minimiza o risco de erro humano.
- Garante aderência consistente às políticas internas e externas (como auditorias periódicas).

Essa abordagem é especialmente útil para equipes DevOps, SRE e segurança que trabalham com infraestruturas na AWS em escala corporativa, ajudando a cumprir práticas como “security by default” e “compliance automation”.

## Extras:

- Foi construido um fluxo de CI/CD (actions) para que quando um PR por aberto para a main, e se tiver sido alterado algo referente ao terraform, que ele rode todo o fluxo padrão da implementação de um Terraform!
- Também foi implementado a forma Manual de chamar o CI e CD, tanto para Plan, Apply ou Destroy!


---

## 🚀 Conclusão (por que eu fiz esse lab?)

Para praticar o uso do Terraform na criação de recursos AWS seguros, aderentes às boas práticas de segurança, auditoria e conformidade.  
Ele mostra na prática como combinar técnicas de segurança (versionamento, criptografia, políticas TLS) com automação (Terraform), algo essencial para qualquer operação em nuvem moderna.

Este conhecimento é diretamente aplicável no mundo real, especialmente em ambientes empresariais ou projetos críticos.
