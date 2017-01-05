################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

Puppet::Type.type(:oneview_fc_network).provide :thunderbird, parent: :c7000 do
  desc 'Provider for OneView Ethernet Networks using the Thunderbird variant of the OneView API'

  confine true: login[:hardware_variant] == 'Thunderbird'

  def initialize(*args)
    @resourcetype ||= Object.const_get("OneviewSDK::API#{login[:api_version]}::Thunderbird::EthernetNetwork")
    super(*args)
  end
end
