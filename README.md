# tf-workspace-reproduce-issue
sample repo demonstrating terraform [issue](https://github.com/hashicorp/terraform/issues/21133) with workspaces

## steps to reproduce
create remote state, setup workspace and demonstrate [issue](https://github.com/hashicorp/terraform/issues/21133)

### setup remote state
1. `cd backend_setup`
1. `terraform init`
1. `terraform plan --out tfplan`
1. `terraform apply tfplan`
1. `cd ..`

remote state is important; this is not reproducible with local state.

_note: don't care about the local state for this bucket itself in this example. :)_

### let's provision some things...
1. `terraform init`
1. `terraform workspace new test`
1. `terraform plan --out tfplan`
1. `terraform apply tfplan`

we've now provisioned an S3 bucket and a silly `null_resource`. [here](https://gist.github.com/mdavis40/f49bc7a15bb68ad6a2f2ca6dca199840#file-initial-apply-tf-state) is the current remote state.

### that all worked, what's the problem?
we need to switch branches to discover the issue. we'll also _simulate_ a CI job, and cleanup `.terraform/`.

1. `git checkout second-branch`
1. `rm -rf .terraform/`
1. `TF_LOG=trace terraform init`
1. `terraform providers`
  * output:
   ```
   [tf-workspace-reproduce-issue]$ terraform providers
   .
   └── provider.aws
   ```
1. `terraform workspace select test`
1. `terraform plan --out tfplan`

and this is where things breakdown, to resolve the issue, continue on...

1. `terraform providers`
  * output:
  ```
  [tf-workspace-reproduce-issue]$ terraform providers
  .
  ├── provider.aws
  └── provider.null (from state)
  ```
1. `terraform init` (now it's going to download the `null` provider)
1. `terraform plan --out tfplan`
1. `terraform apply tfplan`

at this point, the remote state file should only contain the `aws` provider and the `aws_s3_bucket`. the `null` provider and `null_resource` have been destroyed (and thus removed from state).
