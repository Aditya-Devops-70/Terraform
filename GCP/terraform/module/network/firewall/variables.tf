variable "firewall_name" {
  description = "Name of the firewall rule"
  type        = string
}

variable "network" {
  description = "The name or self_link of the network"
  type        = string
}

variable "source_ranges" {
  description = "List of source IP CIDR ranges"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_tags" {
  description = "List of target tags"
  type        = list(string)
}

variable "allow_rules" {
  description = "List of rules with protocol and ports"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
}


variable "description" {
  description = "Optional firewall rule description"
  type        = string
  default     = ""
}