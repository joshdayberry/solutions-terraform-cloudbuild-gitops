provider "google" {
  project = var.project
}

locals {
  local    = var.env == "local" ? "10.10.0.0/16" : ""
  dev    = var.env == "dev" ? "10.20.0.0/16" : ""
  prod    = var.env == "prod" ? "10.30.0.0/16" : ""
  #find the firset not empty var and uses that ip range
  ips_range = coalesce(local.local, local.dev, local.prod, var.subnet_ip)
  ip_ranges = cidrsubnets(local.ips_range, 8, 8, 8)
  vpc_range = local.ip_ranges[0]
  ip_cidr_range_pod = local.ip_ranges[1]
  ip_cidr_range_service = local.ip_ranges[2]

}

module "vpc" {
  source  = "../../modules/vpc"
  project = var.project
  env     = var.env
  subnet_ip = local.vpc_range
  ip_cidr_range_pod = local.ip_cidr_range_pod
  ip_cidr_range_service = local.ip_cidr_range_service
  ip_range_pods_name = var.ip_range_pods_name
  ip_range_services_name = var.ip_range_services_name
  region      = var.region
}

module "gke_auto" {
  source  = "../../modules/gke_auto"
  project = "${var.project}"
  subnet  =  "${module.vpc.subnet}"
  zones   = "${var.zones}"
  env     = "${var.env}"
  region  = "${var.region}"
  network = "${module.vpc.network}"
  ip_range_pods_name = "${var.ip_range_pods_name}"
  ip_range_services_name = "${var.ip_range_services_name}"
}

# module "http_server" {
#   source  = "../../modules/http_server"
#   project = "${var.project}"
#   subnet  = "${module.vpc.subnet}"
# }

module "firewall" {
  source  = "../../modules/firewall"
  project = "${var.project}"
  subnet  = "${module.vpc.subnet}"
}
