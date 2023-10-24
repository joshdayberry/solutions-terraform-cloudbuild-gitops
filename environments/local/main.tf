# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


locals {
  env = "local"
  local    = local.env == "local" ? "10.10.0.0/16" : ""
  dev    = local.env == "dev" ? "10.20.0.0/16" : ""
  prod    = local.env == "prod" ? "10.30.0.0/16" : ""
  #find the firset not empty var and uses that ip range
  ips_range = coalesce(local.local, local.dev, local.prod, var.subnet_ip)
  ip_ranges = cidrsubnets(local.ips_range, 8, 8, 8)
  vpc_range = local.ip_ranges[0]
  ip_cidr_range_pod = local.ip_ranges[1]
  ip_cidr_range_service = local.ip_ranges[2]

}


provider "google" {
  project = "${var.project}"
}

#import {
#  id = "projects/${var.project}/policies/constraints/compute.vmExternalIpAccess"
#  to = google_org_policy_policy.vm_external_ip
#}
#resource "google_org_policy_policy" "vm_external_ip" {
#  name = "projects/${var.project}/policies/constraints/compute.vmExternalIpAccess"
#  parent = "projects/${var.project}"

#  spec {
#    reset = true
#  }
#}


module "vpc" {
  source  = "../../modules/vpc"
  project = "${var.project}"
  env     = "${local.env}"
  subnet_ip = "${local.vpc_range}"
  ip_cidr_range_pod = local.ip_cidr_range_pod
  ip_cidr_range_service = local.ip_cidr_range_service
  ip_range_pods_name = "${var.ip_range_pods_name}"
  ip_range_services_name = "${var.ip_range_services_name}"
  region      = "${var.region}"  
}

module "gke_auto" {
  source  = "../../modules/gke_auto"
  project = "${var.project}"
  subnet  =  "${module.vpc.subnet}"
  zones   = "${var.zones}"
  env     = "${local.env}"
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
