/**
 * # Fortigate VDOM configuration module
 *
 * This terraform module configures VDOMs on a firewall
 */
terraform {
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
    }
  }
}
locals {
  vdom_yaml = yamldecode(file("${var.config_path}/config/vdoms.yaml"))

  vdom_config = [ for vdom in local.vdom_yaml.vdoms : {
    name          = vdom
    id            = index(local.vdom_yaml.vdoms, vdom)
    vlanid        = 4000 + index(local.vdom_yaml.vdoms, vdom)
    root_ipv4     = "${var.vdom_transit_v4}.${(index(local.vdom_yaml.vdoms, vdom) + 2)}/31"
    vdom_ipv4     = "${var.vdom_transit_v4}.${(index(local.vdom_yaml.vdoms, vdom) + 3)}/31"
    root_ipv6     = "${var.vdom_transit_v6}::${(index(local.vdom_yaml.vdoms, vdom) + 2)}/127"
    vdom_ipv6     = "${var.vdom_transit_v6}::${(index(local.vdom_yaml.vdoms, vdom) + 3)}/127"
  }]
}

resource fortios_system_global globalsettings {
  count         = try(local.vdoms_yaml["enable_vdoms"], false) ? 1 : 0
  vdom_mode     = "multi-vdom"
}

resource fortios_system_vdom vdom {
  for_each    = { for vdom in local.vdom_config : vdom.name => vdom }
  name        = each.key
  short_name  = each.key
  temporary   = 0
}

resource fortios_system_interface link_rt {
  for_each      = { for vdom in local.vdom_config : vdom.name => vdom }
  name          = "rt-${each.key}0"
  vlanid        = each.value.vlanid
  interface     = "npu0_vlink0"
  ip            = each.value.root_ipv4
  dynamic "ipv6" {
    for_each    = { for k in ["ipv6"] : k => each.value.root_ipv6 if each.value.root_ipv6 != null }
    content {
      ip6_address         = "${ipv6.value}"
      ip6_send_adv        = "enable"
      ip6_manage_flag     = "enable"
      ip6_other_flag      = "enable"
      ip6_allowaccess     = "ping"
    }
  }
  allowaccess   = "ping"
  vdom          = "root"
}

resource fortios_system_interface link_vdom {
  for_each      = { for vdom in local.vdom_config : vdom.name => vdom }
  depends_on    = [ fortios_system_vdom.vdom ]
  name          = "rt-${each.key}1"
  vlanid        = each.value.vlanid
  interface     = "npu0_vlink1"
  ip            = each.value.vdom_ipv4
  defaultgw     = "disable"
  role          = "wan"
  dynamic "ipv6" {
    for_each    = { for k in ["ipv6"] : k => each.value.vdom_ipv6 if each.value.vdom_ipv6 != null }
    content {
      ip6_address         = "${ipv6.value}"
      ip6_allowaccess     = "ping"
    }
  }
  allowaccess = "ping"
  vdom          = each.key
}
