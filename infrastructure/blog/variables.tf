variable "az_resource_group" {
  type        = string
  description = "Resource group containing the Azure infrastructure of the blog"
}

variable "az_location" {
  type        = string
  description = "Location of the Azure infrastructure elements"
}

variable "root_domain" {
  type        = string
  description = "Root DNS of the blog"
  default     = "an0rak.dev"
}