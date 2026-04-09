# terraform-data-platform

Infrastructure-as-code for a scalable AWS data platform, provisioned and managed with Terraform. This repository defines the core data ingestion, storage, and cataloguing layers across **dev**, **staging**, and **production** environments using reusable modules for Amazon S3, AWS Glue, and IAM.

---

## Repository structure

```
terraform-data-platform/
├── .github/
│   └── workflows/          # CI/CD pipeline definitions
├── environments/
│   ├── dev/                # Dev environment variable overrides
│   ├── staging/            # Staging environment variable overrides
│   └── prod/               # Production environment variable overrides
├── modules/
│   ├── s3/                 # S3 bucket provisioning module
│   ├── glue/               # AWS Glue crawler & job module
│   └── iam/                # IAM roles and policies module
├── main.tf                 # Root module — composes all child modules
├── variables.tf            # Input variable declarations
└── README.md
```

---

## Architecture overview

The platform provisions three layers of AWS infrastructure:

| Layer | Service | Purpose |
|---|---|---|
| Storage | Amazon S3 | Raw, processed, and curated data buckets |
| Cataloguing | AWS Glue | Data crawlers, ETL jobs, and Glue Data Catalog |
| Access control | IAM | Least-privilege roles and policies for all services |

All resources are namespaced by environment (`dev` / `staging` / `prod`) and deployed via the GitHub Actions CI/CD pipeline defined in `.github/workflows/`.

---

## Modules

### `modules/s3`

Provisions S3 buckets for each stage of the data pipeline:

- **Raw bucket** — landing zone for unprocessed source data
- **Processed bucket** — output of Glue ETL transformations
- **Curated bucket** — business-ready, query-optimised data

Configurable options include versioning, lifecycle rules, server-side encryption (SSE-S3 or SSE-KMS), and bucket policies.

### `modules/glue`

Deploys AWS Glue resources for data cataloguing and transformation:

- **Glue Data Catalog database** — logical container for table definitions
- **Glue Crawlers** — discover schema from S3 and populate the catalog
- **Glue ETL Jobs** — PySpark jobs for data processing and transformation

### `modules/iam`

Creates least-privilege IAM roles and inline/managed policies:

- **Glue execution role** — allows Glue jobs to read from raw S3 and write to processed S3
- **Cross-account access role** (optional) — enables federated access from analytics tools
- All policies follow the principle of least privilege and are scoped to specific S3 ARNs and Glue resources

---

## Environments

Environments are managed as separate Terraform workspaces with their own `.tfvars` files under `environments/`.

| Environment | Purpose | State backend |
|---|---|---|
| `dev` | Feature development and integration testing | S3 remote state |
| `staging` | Pre-production validation and load testing | S3 remote state |
| `prod` | Live production workloads | S3 remote state (locked) |

To apply a specific environment:

```bash
terraform init
terraform workspace select dev
terraform apply -var-file="environments/dev/terraform.tfvars"
```

---

## CI/CD pipeline

The `.github/workflows/` directory contains a GitHub Actions pipeline with the following stages:

| Step | Trigger | Description |
|---|---|---|
| `validate` | Every push / PR | Runs `terraform fmt -check` and `terraform validate` |
| `plan` | Pull request | Generates and posts a plan diff as a PR comment |
| `apply` | Merge to `main` | Applies the plan to the target environment |

> **Note:** Step 4 was removed from the pipeline. See commit `550fc3d` for details.

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.3
- AWS CLI configured with appropriate credentials
- An S3 bucket and DynamoDB table for remote state (configured per environment)

---

## Getting started

```bash
# 1. Clone the repo
git clone https://github.com/SnehaGeorge22/terraform-data-platform.git
cd terraform-data-platform

# 2. Initialise Terraform with the remote backend
terraform init

# 3. Select the target environment workspace
terraform workspace select dev   # or staging / prod

# 4. Review the plan
terraform plan -var-file="environments/dev/terraform.tfvars"

# 5. Apply
terraform apply -var-file="environments/dev/terraform.tfvars"
```

---

## Contributing

1. Create a feature branch from `main`
2. Make your changes and run `terraform fmt` and `terraform validate` locally
3. Open a pull request — the CI pipeline will post a Terraform plan as a comment
4. Request a review; merge triggers the apply to the target environment

---

## License

This project is for internal use. Please refer to your organisation's licensing policy.
