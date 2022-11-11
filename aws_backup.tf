resource "aws_kms_key" "rds_kms" {
    description             = "KMS key for RDS Backups to RDS"
    deletion_window_in_days = 7
}

resource "aws_backup_vault" "rds_backup_vault" {
    name = "rds-backup-vault"
    kms_key_arn = aws_kms_key.rds_kms.arn
}

resource "aws_iam_role" "aws_backup" {
  name               = "aws-backup"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "aws_backup_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup.name
}

resource "aws_backup_plan" "rds_backup_plan_hourly" {
    name = "rds-backup-plan-hourly"

    rule {
        rule_name         = "rds-backup-plan-hourly"
        target_vault_name = aws_backup_vault.rds_backup_vault.name
        schedule          = "cron(50 * * * ? *)"

        lifecycle {
            delete_after = 1
        }
    }
}

resource "aws_backup_selection" "rds_backup_selection" {
    name         = "rds-backup"
    iam_role_arn = aws_iam_role.aws_backup.arn
    plan_id      = aws_backup_plan.rds_backup_plan_hourly.id

    resources = [
        aws_db_instance.rds1.arn
    ]
}
