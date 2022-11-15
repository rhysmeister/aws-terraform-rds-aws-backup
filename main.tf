locals {
    allocated_storage        = 10
    engine                   = "mariadb"
    engine_version           = "10.6"
    instance_class           = "db.t3.micro"
    skip_final_snapshot      = true

    username = "admin"
    password = "TopSecret915!"           
    
    snapshot_identifier = "arn:aws:rds:eu-central-1:824543128771:snapshot:awsbackup:job-3157581c-d5fe-972b-4731-3038a09600e9"  
}

resource "aws_db_instance" "rds1" {
    identifier               = "rds1"
    allocated_storage        = local.allocated_storage
    engine                   = local.engine
    engine_version           = local.engine_version
    instance_class           = local.instance_class
    username                 = local.username
    password                 = local.password
    skip_final_snapshot      = local.skip_final_snapshot

    snapshot_identifier      = local.snapshot_identifier   
}

resource "aws_ssm_parameter" "endpoint" {
    name        = "/test/rds/endpoint"
    description = "Endpoint of the active RDS Instance"
    type        = "String"
    value       = aws_db_instance.rds1.endpoint
}

resource "aws_ssm_parameter" "admin_username" {
    name        = "/test/rds/username"
    description = "Username of RDS Instance"
    type        = "String"
    value       = local.username
}

resource "aws_ssm_parameter" "admin_password" {
    name        = "/test/rds/password"
    description = "Password of RDS Instance"
    type        = "SecureString"
    value       = local.password
}