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

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'login'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'common'))
require 'oneview-sdk'

Puppet::Type.type(:oneview_server_hardware_type).provide(:ruby) do
  mk_resource_methods

  def initialize(*args)
    super(*args)
    @client = OneviewSDK::Client.new(login)
    @resourcetype = OneviewSDK::ServerHardwareType
    # Initializes the data so it is parsed only on exists and accessible throughout the methods
    # This is not set here due to the 'resources' variable not being accessible in initialize
    @data = {}
    @authentication = {}
  end

  def self.instances
    @client = OneviewSDK::Client.new(login)
    matches = OneviewSDK::ServerHardwareType.get_all(@client)
    matches.collect do |line|
      name = line['name']
      data = line.inspect
      new(name: name,
          ensure: :present,
          data: data
         )
    end
  end

  # TODO: eventually implement this prefetch method as it seems useful but requires an investigation into it
  # def self.prefetch(resources)
  #   packages = instances
  #   resources.keys.each do |name|
  #     if provider = packages.find { |pkg| pkg.name == name }
  #       resources[name].provider = provider
  #     end
  #   end
  # end

  # Provider methods

  def exists?
    @data = data_parse
    server_hardware_type = @resourcetype.find_by(@client, @data)
    !server_hardware_type.empty?
  end

  def create
    resource_update(@data, @resourcetype)
    true
  end

  def destroy
    server_hardware_type = get_single_resource_instance
    server_hardware_type.delete
    @property_hash.clear
  end

  def found
    find_resources
  end
end
