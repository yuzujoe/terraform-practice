module "allow_ssh" {
  source    = "./security_group"
  allow_ssh = true
}

module "disallow_ssh" {
  source    = "./security_group"
  allow_ssh = false
}

output "allow_ssh_rule_id" {
  value = module.allow_ssh.allow_ssh_rule_id
}

output "disallow_ssh_rule_id" {
  value = module.disallow_ssh.allow_ssh_rule_id
}
