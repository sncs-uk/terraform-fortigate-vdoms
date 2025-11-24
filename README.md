<!-- BEGIN_TF_DOCS -->
# Fortigate VDOM configuration module

This terraform module configures VDOMs on a firewall

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_fortios"></a> [fortios](#provider\_fortios) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [fortios_system_global.globalsettings](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_global) | resource |
| [fortios_system_interface.link_rt](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_interface) | resource |
| [fortios_system_interface.link_vdom](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_interface) | resource |
| [fortios_system_vdom.vdom](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/system_vdom) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_path"></a> [config\_path](#input\_config\_path) | Path to base configuration directory | `string` | n/a | yes |
| <a name="input_vdom_transit_v4"></a> [vdom\_transit\_v4](#input\_vdom\_transit\_v4) | v4 transit network, first three octets | `string` | `"100.64.0"` | no |
| <a name="input_vdom_transit_v6"></a> [vdom\_transit\_v6](#input\_vdom\_transit\_v6) | v4 transit network, first parts | `string` | `"fe80"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->