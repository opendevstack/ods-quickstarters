require 'aws-sdk'
require 'ipaddr'
require 'singleton'

module SpecHelper
  class AWS
    # See https://docs.aws.amazon.com/sdkforruby/api/Aws.html
    class SDK
      include Singleton

      def client(clazz, region = ENV['AWS_DEFAULT_REGION'])
        client_clazz = Module.const_get(clazz.to_s + '::Client')
        client_clazz.new(region: region)
      end

      def resource(clazz, region = ENV['AWS_DEFAULT_REGION'])
        client = client(clazz, region)

        resource_clazz = Module.const_get(clazz.to_s + '::Resource')
        resource_clazz.new(client: client)
      end
    end

    def self.sdk
      return SDK.instance
    end

    def self.convert_aws_tags_to_hash(tags)
      results = {}

      tags.each do |tag|
        results[tag.key] = tag.value
      end

      results
    end

    def self.convert_tags_hash_to_array(tags)
      tags.to_a.map do |tag|
        { key: tag.first.to_s, value: tag.last }
      end
    end

    def self.convert_tags_hash_to_aws_filters(tags)
      tags.to_a.map do |tag|
        { name: "tag:#{tag.first}", values: [tag.last] }
      end
    end

    def self.filter_resources(resource, type, filters)
      matches = resource.send(type, { filters: filters }).map(&:id)

      if matches.count == 1
        matches[0]
      elsif matches.count == 0
        STDERR.puts "Error: could not find any resources of type '#{type}' with tag:Name = '#{name}'"
        []
      else
        STDERR.puts "Error: there is more than one resource of type '#{type}' with tag:Name = '#{name}'"
        matches
      end
    end

    def self.get_asg_name_by_tags(tags, region = ENV['AWS_DEFAULT_REGION'])
      client = self.sdk.client(Aws::AutoScaling, region)

      # Convert the incoming tags into an array
      tags = convert_tags_hash_to_array(tags)

      names = client.describe_auto_scaling_groups().data['auto_scaling_groups'].find_all { |group|
        # Convert the auto scaling group's tags into an array
        group_tags = group.tags.map do |tag|
          { key: tag.key, value: tag.value }
        end

        # Check if all incoming tags are present in the auto scaling group
        (tags - group_tags).empty?
      }.map(&:auto_scaling_group_name)

      if names.count == 1
        names[0]
      elsif names.count == 0
        STDERR.puts "Error: could not find any auto scaling group with tags = '#{tags}'"
        []
      else
        STDERR.puts "Error: there is more than one auto scaling group with tags = '#{tags}'"
        names
      end
    end

    def self.get_ec2_instance_id_by_tags(tags, region = ENV['AWS_DEFAULT_REGION'])
      filters = convert_tags_hash_to_aws_filters(tags)
      filters << { name: 'instance-state-name', values: ['pending', 'running'] }

      # See https://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Resource.html#instances-instance_method.
      filter_resources(self.sdk.resource(Aws::EC2, region), 'instances', filters)
    end

    def self.get_rds_instance_id_by_tags(tags, region = ENV['AWS_DEFAULT_REGION'])
      client = self.sdk.client(Aws::RDS, region)

      # Convert the incoming tags into an array
      tags = convert_tags_hash_to_array(tags)

      ids = client.describe_db_instances().db_instances.find_all { |instance|
        resp = client.list_tags_for_resource({ :resource_name => instance.db_instance_arn })
        if resp.nil? or resp.tag_list.empty?
          STDERR.puts "Error: could not find any RDS database instance with tags = '#{tags}'"
          return []
        end

        # Check if all incoming tags are present in the RDS database instance
        instance_tags = convert_tags_hash_to_array(convert_aws_tags_to_hash(resp.tag_list))
        (tags - instance_tags).empty?
      }.map(&:db_instance_identifier)

      if ids.count == 1
        ids[0]
      elsif ids.count == 0
        STDERR.puts "Error: could not find any RDS database instance with tags = '#{tags}'"
        []
      else
        STDERR.puts "Error: there is more than one RDS database instance with tags = '#{tags}'"
        ids
      end
    end

    def self.get_security_group_id_by_tags(tags, region = ENV['AWS_DEFAULT_REGION'])
      filters = convert_tags_hash_to_aws_filters(tags)

      # See https://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Resource.html#security_groups-instance_method.
      filter_resources(self.sdk.resource(Aws::EC2, region), 'security_groups', filters)
    end

    def self.get_vpc_id_by_tags(tags, region = ENV['AWS_DEFAULT_REGION'])
      filters = convert_tags_hash_to_aws_filters(tags)

      # See https://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Resource.html#vpcs-instance_method.
      filter_resources(self.sdk.resource(Aws::EC2, region), 'vpcs', filters)
    end

    def self.get_subnet_ids_by_vpc_id(id, region = ENV['AWS_DEFAULT_REGION'])
      # See https://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Resource.html#vpc-instance_method.
      vpc = self.sdk.resource(Aws::EC2, region).vpc(id)

      unless vpc.nil?
        # See https://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Vpc.html#subnets-instance_method.
        vpc.subnets().sort_by { |subnet|
          IPAddr.new(subnet.cidr_block)
        }.map(&:id)
      else
        STDERR.puts "Error: could not find a VPC with ID = '#{id}'"
        []
      end
    end

    private_constant :SDK
    private_class_method :convert_tags_hash_to_aws_filters
    private_class_method :filter_resources
  end
end
