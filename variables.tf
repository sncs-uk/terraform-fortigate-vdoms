variable config_path {
  description = "Path to base configuration directory"
  type        = string
}

variable vdom_transit_v4 {
  description = "v4 transit network, first three octets"
  type        = string
  default     = "100.64.0"
}

variable vdom_transit_v6 {
  description = "v4 transit network, first parts"
  type        = string
  default     = "fe80"
}
