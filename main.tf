# Define required providers
terraform {
  # Ensure the use of a compatible Terraform version
  required_version = ">= 0.14.0"
  required_providers {
    # Define OpenStack terraform provider
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 2.0.0"
    }
    infomaniak = {
      source  = "Infomaniak/infomaniak"
      version = "1.4.1"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  auth_url    = "https://api.pub1.infomaniak.cloud/identity"
  region      = "dc3-a"
  user_name   = "PCU-L4HZJ69" # TODO: changeme
  tenant_name = "PCP-AGHLSED" # TODO: changeme
  password    = "password" # TODO: changeme
}

provider "infomaniak" {
    token   = "$INFOMANIAK_API_TOKEN"
    # Remember to set the API token as env variable
}

resource "infomaniak_kaas" "cluster" {
    public_cloud_id             = 17701 # TODO: changeme
    public_cloud_project_id     = 39034 # TODO: changeme
    name                        = "my-cluster"
    pack_name                   = "dedicated_4"
    kubernetes_version          = "1.33"
    region                      = "dc3-a"
}

resource "infomaniak_kaas_instance_pool" "workers" {
    public_cloud_id             = infomaniak_kaas.cluster.public_cloud_id
    public_cloud_project_id     = infomaniak_kaas.cluster.public_cloud_project_id
    kaas_id                     = infomaniak_kaas.cluster.id
    name                        = "worker-pool"
    flavor_name                 = "a4-ram16-disk80-perf1" # TODO: changeme
    availability_zone           = "dc3-a-04" #TODO: find the difference between [dc3-a-04 dc3-a-09 dc3-a-10
    min_instances               = 2
    max_instances               = 2
}

output "kubeconfig" {
    value = infomaniak_kaas.cluster.kubeconfig
    sensitive = true
}
