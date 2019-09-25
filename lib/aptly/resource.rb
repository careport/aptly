module Aptly
  class Resource
    def self.def_attr(attr_name, *path)
      define_method attr_name do
        @data[attr_name.to_s]
      end
    end

    def self.def_href(link_name)
      define_method "#{link_name}_href".to_sym do
        @data.dig("_links", link_name.to_s, "href")
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
