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


module "kubernetes-engine_beta-autopilot-public-cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  project_id                 = "${var.project}"
  name                       = "${var.project}-${var.env}-gke"
  region                     = "${var.region}"
  zones                      = "${var.zones}"
  network                    = "${var.network}"
  subnetwork                 = "${var.subnet}"
  ip_range_pods              = "${var.ip_range_pods_name}"
  ip_range_services          = "${var.ip_range_services_name}"
  horizontal_pod_autoscaling = true
  
}
