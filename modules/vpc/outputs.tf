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


output "network" {
  value = "${module.vpc.network_name}"
}

output "subnet" {
  value = "${element(module.vpc.subnets_names, 0)}"
}

output "ip_range_pods_name" {
  #value = "${element(module.vpc.subnets_secondary_ranges, 0)}"
  value = "ip-range-pods"
  #value = "${element(module.vpc.subnets_secondary_ranges, 0)}"
}

output "ip_range_services_name" {
  value = "ip-range-ip_range_services"
  #value = "${element(module.vpc.subnets_secondary_ranges, 1)}"
}