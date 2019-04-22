module Aptly
  class App < Resource
    def_attr :id
    def_attr :handle

    def services
      @data.dig("_embedded", "services").map do |service_data|
        Service.new(@access_token, service_data)
      end
    end
  end
end
