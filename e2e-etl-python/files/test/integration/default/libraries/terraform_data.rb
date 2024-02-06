require 'json'

module SpecHelper
  class TerraformData
    @data

    def initialize(path = '.terraform-data.json')
      @data = JSON.parse(File.read(path))
    end

    def [](key)
      @data[key]
    end
  end
end
