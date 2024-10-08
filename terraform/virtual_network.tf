module "virtual_network" {
  source  = "Retoxx-dev/virtual-network/azurerm"
  version = "1.0.3"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name = "vnet-${local.project_name}"

  address_space = ["10.0.0.0/22"]

  subnets = [
    {
      name             = "snet-${local.project_name}-kubernetes"
      address_prefixes = [cidrsubnet("10.0.0.0/22", 2, 0)]
    }
  ]

  tags = local.tags
}
