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

3. **Create a Key Pair in AWS (Or Make Sure You Have an Existing Key Pair)**

   You need to specify a key pair as part of the provisioning process. This gets used in the EC2 provisioning so that you can SSH into the EC2 instance from the terminal of your local machine.

   For more information on EC2 key pairs: [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html).

4. **Make Sure You're in the `aws` Directory**

   You need to be in the directory with the `.tf` files for the following commands to work.

   ```bash
   cd aws
   ```

5. **Initialize Terraform**

   ```bash
   terraform init
   ```

6. **Preview the Plan**

   ```bash
   terraform plan
   ```

7. **Apply the Configuration**

   ```bash
   terraform apply
   ```

   Confirm with yes to deploy.

8. **Check Outputs**

   After apply completes, Terraform will output:

   - EC2 public IP

   - ECS cluster name

   - Task definition ARN

   - Log group name

9. **If You Want to Teardown**

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
