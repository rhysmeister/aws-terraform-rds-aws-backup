# aws-terraform-rds-aws-backup
A simple Terraform module using RDS and AWS Backup to perform backup &amp; restore

# A note about secrets

Please note that the DB Master password is contained within the Terraform code and will be stored in the state. Look at [Sensitive Data in State](https://developer.hashicorp.com/terraform/language/state/sensitive-data) for more information and be sure to secure this value for any non-trivial usage.

# Initial deployment

It is assumed that snapshot_identifier variable is set to null.

```bash
terraform apply
```

The AWS Backup Plan that has been created is set to run hourly. Be sure to wait for at least one restore point to be available.

# Restoration

First we need to destroy the RDS Instance...

```bash
terraform destroy --target aws_db_instance.rds1
````

This will destroy the following two resources...

* aws_backup_selection.rds_backup_selection
* aws_db_instance.rds1

Set the variable snapshot_identifier to the ARN of a backup you want to restore.

```bash
terraform apply
```

This will recreate the backup select and RDS resources.

# Clean up

You'll need to manually delete any restore points before you can proceed. Then just run...

```bash
terraform destroy
```

# TODO

* Add Parameter store values for endpoint, username and password.
* version of module with continuous backup.