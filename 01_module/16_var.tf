variable "name" {
  type = string
}
variable "key" {
  type = object({
    name    = string
    public  = string
    private = string
  })
}
variable "region" {
  type = object({
    region = string
    az     = list(string)
  })
}
variable "cidr" {
  type = object({
    vpc = string
    pub = list(string)
    web = list(string)
    was = list(string)
    db  = list(string)
  })
}
variable "sg_bastion" {
  type = object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  })
}
variable "sg_web" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
  }))
}
variable "sg_was" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
  }))
}
variable "sg_db" {
  type = object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
  })
}
variable "bastion" {
  type = object({
    ami           = string
    instance_type = string
  })
}
variable "web" {
  type = object({
    count         = number
    ami           = string
    instance_type = string
  })
}
variable "was" {
  type = object({
    count         = number
    ami           = string
    instance_type = string
  })
}
variable "nlb" {
  type = object({
    port     = number
    protocol = string
  })
}
variable "database" {
  type = object({
    allocated_storage = number
    engine            = string
    engine_version    = string
    instance_class    = string
    multi_az          = string
    name              = string
    username          = string
    password          = string
    backup_window     = string
    storage_type      = string
  })
}



variable "lacf_web" {
  type = object({
  instance_type = string
  })
}

variable "lacf_was" {
  type = object({
  instance_type = string
  })
}

variable "atsg_web" {
  type = object({
  min_size                  = number
  max_size                  = number
  health_check_grace_period = number
  health_check_type         = string
  desired_capacity          = number
  })
}

variable "atsg_was" {
  type = object({
  min_size                  = number
  max_size                  = number
  health_check_grace_period = number
  health_check_type         = string
  desired_capacity          = number
  })
}

variable "backup" {
  type = object({
    interval      = number
    interval_unit = string
    times         = list(string)
    count         = number
  })
}
variable "lambda" {
  type = object({
    cw_s3  = string
    s3_ses = string
  })
}