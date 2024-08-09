require 'json'

module SpecHelper
  class FixtureData
    @data

    def json_vars?()
      ENV.has_key?('JSON_VARS_FILE') and ENV['JSON_VARS_FILE'] != ''
    end

    def initialize(suite = 'default')
      if json_vars? then
        @data = JSON.parse(File.read(ENV['JSON_VARS_FILE']))
      else
        @data = JSON.parse(File.read('test/integration/' + suite + '/files/main.json'))
        extract_first_element_of_array(@data)
      end
    end

    def locals
      json_vars? ? @data : extract_first_element_of_array(@data['locals'])
    end

    def for_module(name = nil)
      json_vars? ? @data : extract_first_element_of_array(@data['module'].select { |x| x[name] }.first[name])
    end

    def for_resource(type = nil, name = nil)
      tdata = @data['resource'].select { |x| x[type] }      # array having all resources of given type
      tdata = tdata.select { |x| x[type][name] }.first      # select the item matching resource name
      extract_first_element_of_array(tdata[type][name])     # trim given structure
      json_vars? ? @data : tdata[type][name]
    end

    private :json_vars?

    private

    def extract_first_element_of_array(myhash = nil)
      myhash.each do |k, v|
        if !(['module', 'resource', 'data'].include? k.to_s)
          if v.kind_of?(Array)
            myhash[k] = v[0]
          end
        end
      end
    end
  end
end
