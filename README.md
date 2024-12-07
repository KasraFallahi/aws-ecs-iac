# Building the Cloud Infrastructure

## Objective

- Use Terraform to create an AWS Elastic Container Registry (ECR) and push the Docker images built in the previous step to the repository.
- Use Terraform to create an AWS Elastic Container Service (ECS) cluster that integrates with the ECR repository, enabling the deployment of Docker images to EC2 instances.

## Challenges and Solutions

### 1. Designing the AWS Infrastructure

- **Challenge**: The first challenge was designing an abstract architecture to identify the relationships between key components of the project, including AWS ECR, ECS, and GitLab CI/CD. Once the abstract architecture was clear, the next challenge was defining all the basic AWS resources required for creating and managing an ECS cluster.
- **Solution**: The abstract architecture diagram helped to visualize the interactions between the components, guiding the design of the infrastructure. A comprehensive list of resources was then defined, including ECR, ECS, EC2 instances, VPC, and IAM roles, ensuring that each resource had clear definitions and dependencies.

  <img src="../documentation-images/aws-diagram.webp" height="250" />

#### Infrastructure Table

| **Component**          | **Resource/Service** | **Purpose/Description**                                  | **Terraform File**                                     |
| ---------------------- | -------------------- | -------------------------------------------------------- | ------------------------------------------------------ |
| **Container Registry** | AWS ECR              | Stores Docker images used by ECS tasks and instances.    | [ecr module](./modules/ecr)                            |
| **ECS Cluster**        | AWS ECS              | Manages the deployment and operation of containers.      | [ecs-cluster module](./modules/ecs)                    |
| **EC2 Instances**      | AWS EC2              | Instances running in the ECS cluster to host containers. | [launch-template.tf](./modules/ecs/launch-template.tf) |
| **VPC**                | AWS VPC              | Virtual network for ECS and other AWS resources.         | [vpc module](./modules/vpc)                            |
| **IAM Roles**          | Various IAM Roles    | Define permissions for ECS tasks, instances, and users.  | See IAM Roles Table below                              |

### 2. IAM Users and Roles Configuration

- **Challenge**: Properly defining the IAM users and roles required for Terraform, GitLab, and ECS services. Security and precise access control are paramount when creating and assigning IAM roles and policies.
- **Solution**: IAM elements were defined as follows, with attention to the security implications and clear documentation of each user, role, and policy:

#### 2.1 Terraform User

- **Role**: A user to interact with Terraform for managing AWS resources.
- **Challenge**: This user must be able to create, manage, and destroy resources like IAM, ECR, ECS, EC2, and VPC.
- **Solution**: The Terraform user was created via CloudShell or the AWS Console. The attached policy must be carefully documented and permissions restricted to avoid unnecessary access, as the original policy had several dangerous and unnecessary permissions.

#### 2.2 GitLab User

- **Role**: This user is automatically created by Terraform to access the ECR repository for pulling Docker images.
- **Solution**: The policy and role for the GitLab user are defined in the [GitLab User IAM configuration](./modules/iam/gitlab-user.tf), ensuring that the necessary permissions are granted only for interacting with the ECR repository.

#### 2.3 ECS Instance Role

- **Role**: This EC2 role allows ECS instances to pull container images from ECR and register with ECS.
- **Solution**: The ECS instance role is defined in the [ECS Instance Role Terraform configuration](./modules/iam/ecs-instance-role.tf) and attached to the EC2 instances using a [Launch Template](./modules/ecs/launch-template.tf).

#### 2.4 ECS Task Execution Role

- **Role**: This role provides necessary permissions for ECS Tasks to execute with specific permissions.
- **Solution**: The ECS task execution role is defined in the [ECS Task Execution Role Terraform configuration](./modules/iam/ecs-task-execution-role.tf) and used in the [Task Definition configuration](./modules/ecs/task-definition.tf).

### 3. Defining the ECR Component

- **Challenge**: Setting up the Elastic Container Registry (ECR) to securely store Docker images while implementing a lifecycle policy to manage repository data efficiently.
- **Solution**: A modular Terraform setup was used to define the ECR repository. The lifecycle policy ensures unused images are removed, optimizing storage costs and maintaining a clean repository.

#### ECR Components Table

| **Component**        | **Description**                                                                      | **Terraform File**                                                     |
| -------------------- | ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------- |
| **ECR Repository**   | Defines the container image repository in AWS ECR.                                   | [main.tf](./terraform/modules/ecr/main.tf)                             |
| **Lifecycle Policy** | Configures a policy to clean up unused images based on defined retention criteria.   | [lifecycle-policy.json](./terraform/modules/ecr/lifecycle-policy.json) |
| **Outputs**          | Provides the repository URI and other details required by other modules (e.g., ECS). | [outputs.tf](./terraform/modules/ecr/outputs.tf)                       |
| **Variables**        | Input variables to configure ECR repository attributes dynamically.                  | [variables.tf](./terraform/modules/ecr/variables.tf)                   |

### 4. Defining the VPC Component

- **Challenge**: Creating a Virtual Private Cloud (VPC) that securely and efficiently connects the ECS cluster, EC2 instances, and other AWS resources. The challenge involved defining subnets, route tables, internet gateways, and security groups to meet project requirements.
- **Solution**: A modularized Terraform setup was implemented to define the VPC and its components. Each component was clearly separated into its own file for better organization, reusability, and ease of debugging.

#### VPC Components Table

| **Component**        | **Description**                                                                    | **Terraform File**                                     |
| -------------------- | ---------------------------------------------------------------------------------- | ------------------------------------------------------ |
| **VPC**              | The main virtual network that provides isolated networking for resources.          | [main.tf](./modules/vpc/main.tf)                       |
| **Subnets**          | Subdivisions of the VPC, segregating resources across multiple Availability Zones. | [subnets.tf](./modules/vpc/subnets.tf)                 |
| **Route Tables**     | Define routing rules for directing traffic between subnets and the internet.       | [route_tables.tf](./modules/vpc/route_tables.tf)       |
| **Internet Gateway** | Enables communication between the VPC and the internet.                            | [igw.tf](./modules/vpc/igw.tf)                         |
| **Security Groups**  | Act as virtual firewalls to control inbound and outbound traffic.                  | [security_groups.tf](./modules/vpc/security_groups.tf) |
| **Variables**        | Input variables for configuring the VPC components dynamically.                    | [variables.tf](./modules/vpc/variables.tf)             |
| **Outputs**          | Exports key attributes of the VPC and its components for use by other modules.     | [outputs.tf](./modules/vpc/outputs.tf)                 |

### 5. Defining the ECS Component

- **Challenge**: Configuring the ECS cluster and its associated components, including autoscaling, load balancing, and task definitions, was complex. It required precise integration with other AWS services, such as ECR, EC2, and VPC, while ensuring scalability and high availability.
- **Solution**: A modular Terraform setup was used to define the ECS cluster and its components. Each component was encapsulated in its own file, making the configuration easier to maintain and extend.

#### ECS Components Table

| **Component**         | **Description**                                                                                | **Terraform File**                                         |
| --------------------- | ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| **ECS Cluster**       | Defines the ECS cluster where containerized tasks are managed.                                 | [ecs-cluster.tf](./modules/ecs/ecs-cluster.tf)             |
| **Capacity Provider** | Configures capacity providers for the ECS cluster to manage EC2 instances.                     | [capacity_provider.tf](./modules/ecs/capacity_provider.tf) |
| **Autoscaling Group** | Manages the EC2 instances that host ECS tasks, with dynamic scaling policies.                  | [autoscaling-group.tf](./modules/ecs/autoscaling-group.tf) |
| **Launch Template**   | Specifies the configuration for EC2 instances, including AMI, security groups, and IAM roles.  | [launch-template.tf](./modules/ecs/launch-template.tf)     |
| **Load Balancer**     | Distributes incoming traffic across ECS services for high availability and fault tolerance.    | [loadbalancer.tf](./modules/ecs/loadbalancer.tf)           |
| **ECS Service**       | Manages the deployment and scaling of ECS tasks within the cluster.                            | [ecs-service.tf](./modules/ecs/ecs-service.tf)             |
| **Task Definition**   | Defines the container specifications, including image, CPU, memory, and environment variables. | [task-definition.tf](./modules/ecs/task-definition.tf)     |
| **Shell Script**      | Provides a helper script for initializing or managing ECS components manually.                 | [ecs.sh](./modules/ecs/ecs.sh)                             |
| **Variables**         | Input variables for configuring ECS components dynamically.                                    | [variables.tf](./modules/ecs/variables.tf)                 |

## Testing and Validation

I tested this setup running on my local computer using the AWS Free Tier. All of the components were created successfully, (except some resources in the last run)but there was no time to fully test connecting to them. Below are the details of the testing process, including the Terraform commands used and the ECR functionality test. Also you can find the creation results in terraform state files.

### Terraform Commands Used:

To create the infrastructure components, I used the following Terraform commands:

- **Initialize Terraform Configuration**:  
  `terraform init`

- **Validate the Configuration**:  
  `terraform validate`

- **Generate Execution Plan (for a specific module)**:  
  `terraform plan -target=module.[module-name] -auto-approve`

- **Apply Changes (for a specific module)**:  
  `terraform apply -target=module.[module-name]`

- **Destroy Infrastructure (for a specific module)**:  
  `terraform destroy -target=module.[module-name]`

### ECR Functionality Test (Locally):

To test the ECR functionality locally, I used the following AWS CLI command to authenticate Docker to the Amazon ECR registry:

```bash
aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<your-region>.amazonaws.com
```

## Improvements and Future Plans

### 1. **Store AWS Secrets and Access Keys in Secret Manager**

**Current State**: Currently, AWS access and secret keys are manually handled within the GitLab CI/CD pipeline.

**Future Plan**: Store AWS access and secret keys securely in AWS Secrets Manager. This will enhance security and automate the process of setting secrets on the GitLab CI/CD pipeline using AWS CLI, avoiding hardcoded credentials.

### 2. **Run Terraform on CI/CD**

**Current State**: Terraform is manually run for deployment.

**Future Plan**: Automate Terraform runs within the CI/CD pipeline to improve the consistency and speed of deployments. This will ensure infrastructure is provisioned and updated automatically as code changes are committed.

### 3. **Define Methods to Connect to EC2 Instances**

**Current State**: SSH connectivity to EC2 instances is not fully defined.

**Future Plan**: Implement methods for connecting to EC2 instances securely, including setting up SSH keys, configuring the instances for secure access, and defining connection protocols.

### 4. **Design Comprehensive Architecture Diagrams**

**Current State**: There is no visual representation of the architecture and its components.

**Future Plan**: Design and implement comprehensive diagrams to show the relations between components like AWS ECR, ECS, and GitLab CI/CD. This will help visualize the entire infrastructure and its dependencies, improving understanding and communication.

### 5. **Create Private Subnets for VPC**

**Current State**: The VPC is set up for public subnets only.

**Future Plan**: Create private subnets within the VPC to securely connect internal services, such as databases and S3, while keeping them isolated from the public internet for enhanced security.

### 6. **Store Terraform State File in a Remote Backend**

**Current State**: The Terraform state file is not stored remotely.

**Future Plan**: Store the Terraform state file in a remote backend like GitLab features or AWS S3 buckets. This will ensure better collaboration, state consistency, and disaster recovery capabilities.

### 7. **Design and Implement IAM Components with Precision**

**Current State**: IAM components are configured but lack precise effort and documentation.

**Future Plan**: Design and implement IAM components with more detailed precision, following the principle of least privilege. Thoroughly document every IAM policy, role, and user to ensure security and compliance.

### 8. **Define Stress Tests for ECS Cluster**

**Current State**: Stress tests are not defined for the ECS cluster.

**Future Plan**: Define and implement stress tests to evaluate the ECS cluster's functionality under varying load conditions. This will help assess performance and ensure the infrastructure can scale efficiently.

### 9. **Define Centralized Monitoring and Logging Solutions**

**Current State**: Monitoring and logging are not centralized across the infrastructure.

**Future Plan**: Implement centralized monitoring and logging solutions using tools like AWS CloudWatch, ELK stack, or other third-party solutions to collect logs, metrics, and alarms for infrastructure health and troubleshooting.

### 10. **Add Tests for Infrastructure Validation**

**Current State**: No automated tests are currently in place to validate infrastructure.

**Future Plan**: Implement tests to validate the infrastructure after deployment, ensuring it meets functional and security requirements. This can include integration tests, compliance checks, and performance benchmarks.

### 11. **Optimize Costs**

**Current State**: The infrastructure is designed with functionality in mind, but cost optimization is not a primary focus.

**Future Plan**: Use AWS Cost Explorer to analyze usage and optimize cost efficiency by refining EC2 instance types, auto-scaling policies, load balancer configurations, and other AWS services to reduce unnecessary expenditures.

## References

- [Terraform AWS Provider Documentations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Documentations](https://docs.aws.amazon.com/)
