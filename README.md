#  Construindo uma Aplicação Serverless na AWS com Node.js e Terraform ️

Este repositório demonstra a criação de uma aplicação serverless simples para registro e busca de usuários na AWS, utilizando Node.js e Terraform. O objetivo principal é fornecer um exemplo funcional e didático, aplicando boas práticas de desenvolvimento e infraestrutura como código (IaC).

## ️ Arquitetura

A aplicação foi construída utilizando os seguintes serviços da AWS:

- **AWS Lambda:** Funções Lambda em Node.js para implementar a lógica de negócios, incluindo endpoints para registrar e consultar usuários.
- **Amazon S3:** Armazenamento dos arquivos da aplicação em um bucket S3, garantindo alta disponibilidade e escalabilidade.
- **Amazon DynamoDB:** Banco de dados NoSQL DynamoDB para persistir os dados dos usuários de forma eficiente.
- **Amazon API Gateway:** Configuração do API Gateway para expor os endpoints REST da aplicação e integrá-los com as funções Lambda.

## ⚙️ Provisionamento com Terraform

A infraestrutura da AWS foi provisionada e gerenciada utilizando Terraform, permitindo o versionamento, rastreamento e replicação da infraestrutura de forma segura e eficiente.

##  Implantação

1. Clone este repositório.
2. Configure suas credenciais da AWS.
3. Execute `terraform init` para inicializar o Terraform.
4. Execute `terraform plan` para visualizar as alterações que serão feitas na infraestrutura.
5. Execute `terraform apply` para provisionar os recursos na AWS.

##  Desenvolvimento

A aplicação foi desenvolvida em Node.js e possui os seguintes endpoints:

- `POST /users`: Endpoint para registrar um novo usuário.
- `GET /users`: Endpoint para consultar usuários.

##  Empacotamento

A aplicação é empacotada em um arquivo `.zip` para ser enviado para o S3 e utilizado pelas funções Lambda.

##  Configuração

As configurações da aplicação, como o nome do bucket S3 e da tabela DynamoDB, podem ser ajustadas nos arquivos de configuração do Terraform.

##  Recursos

- [Documentação do AWS Lambda](https://aws.amazon.com/lambda)
- [Documentação do Amazon S3](https://aws.amazon.com/s3)
- [Documentação do Amazon DynamoDB](https://aws.amazon.com/dynamodb)
- [Documentação do Amazon API Gateway](https://aws.amazon.com/apigateway)
- [Documentação do Terraform](https://www.terraform.io)

##  Contribuição

Contribuições são sempre bem-vindas! Sinta-se à vontade para abrir issues e enviar pull requests.

##  Licença

Este projeto está sob a licença MIT.

---

Sinta-se à vontade para adaptar este README.md de acordo com as necessidades específicas do seu projeto. Adicione mais detalhes sobre a implementação, como exemplos de código, diagramas de arquitetura e instruções de como executar a aplicação localmente.
