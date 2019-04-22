module Aptly
  class Resource
    def self.def_attr(attr_name, *path)
      define_method attr_name do
        path = [attr_name] if path.empty?
        string_path = path.map(&:to_s)
        @data.dig(*string_path)
      end
    end

    def initialize(access_token, data)
      @access_token = access_token
      @data = data
    end

    def href
      @data.dig("_links", "self", "href")
    end

    def reload
      @data = @access_token.get(href).parsed
    end
  end
end
