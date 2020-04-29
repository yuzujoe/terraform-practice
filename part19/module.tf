module "allow_ssh" {
  source    = "./security_group"
  allow_ssh = true
}

module "disallow_ssh" {
  source    = "./security_group"
  allow_ssh = false
}

module "simple_sg" {
  source = "./simple_security_group"
  ports  = [80, 443, 8080]
}

module "complex_sg" {
  source = "./complex_security_group"

  ingress_rules = {
    http = {
      port        = 80
      cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    }
    https = {
      port        = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
    redirect_http_to_https = {
      port        = 8080
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "allow_ssh_rule_id" {
  value = module.allow_ssh.allow_ssh_rule_id
}

output "disallow_ssh_rule_id" {
  value = module.disallow_ssh.allow_ssh_rule_id
}
