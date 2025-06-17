# Scheduling System Infrastructure (Terraform)

This project defines the full AWS infrastructure for a scheduling system using **Terraform**. It is specific to AWS (hence the [`aws` folder](aws/)). It provisions:

- A public **VPC** with networking components
- An **EC2 instance** for running the FastAPI backend and PostgreSQL database
- A **DynamoDB table** to store scheduling metadata
- An **S3 bucket** for storage
- An **ECS Fargate task definition** for running the heavy-duty scheduler on demand
- All necessary **IAM roles and policies**

## Explanation of Files

- **[provider.tf](aws/provider.tf)** AWS provider config, region via variable

- **[vpc.tf](aws/vpc.tf)** VPC, subnet, route table, internet gateway

- **[ec2.tf](aws/ec2.tf)** EC2 instance, IAM role, security group

- **[ecs.tf](aws/ecs.tf)** ECS cluster, task, IAM roles, CloudWatch logs

- **[dynamodb.tf](aws/dynamodb.tf)** DynamoDB table

- **[s3.tf](aws/s3.tf)** S3 bucket

- **[variables.tf](aws/variables.tf)** Input variables (region, names, etc.)

## How to Use

1. **Install Terraform**

   Follow instructions at [https://developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install).

2. **Configure AWS Credentials**

   Set up named profiles (e.g., `admin-user`) using:

   ```bash
   aws configure --profile admin-user
   ```

   Or export credentials:

   ```bash
   export AWS_ACCESS_KEY_ID=...
   export AWS_SECRET_ACCESS_KEY=...
   export AWS_PROFILE=admin-user
   ```

3. **Make Sure You're in the `aws` Directory**

   You need to be in the directory with the `.tf` files for the following commands to work.

   ```bash
   cd aws
   ```

4. **Initialize Terraform**

   ```bash
   terraform init
   ```

5. **Preview the Plan**

   ```bash
   terraform plan
   ```

6. **Apply the Configuration**

   ```bash
   terraform apply
   ```

   Confirm with yes to deploy.

7. **Check Outputs**

   After apply completes, Terraform will output:

   - EC2 public IP

   - ECS cluster name

   - Task definition ARN

   - Log group name

8. **If You Want to Teardown**

   To delete all provisioned resources:

   ```bash
   terraform destroy
   ```

   Confirm with yes.

## Notes

- ECS tasks are launched on-demand by the backend using the Python `boto3` library.

- No load balancer is used; the EC2 instance is accessible via public IP.

- Only one public subnet is defined, but you can expand to multi-AZ later.

- All IAM policies use least-privilege permissions.
