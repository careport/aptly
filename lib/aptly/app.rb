module Aptly
  class App < Resource
    def_attr :id
    def_attr :handle

    def_href :operations
    def_href :current_configuration

    def services
      @data.dig("_embedded", "services").map do |service_data|
        Service.new(@access_token, service_data)
      end
    end

    # The Operation returned by #deprovision! may return a 404 error
    # when reloaded or when #wait_for_completion is called on it,
    # because once the app is destroyed, the operation URL doesn't
    # refer to anything. So callers should be ready to deal with 404s.
    def deprovision!
      response = @access_token.post(
        operations_href,
        body: { type: "deprovision" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      Operation.new(@access_token, response.parsed)
    end

    def current_configuration
      response = @access_token.get(current_configuration_href)
      Configuration.new(@access_token, response.parsed)
    end

    def add_to_configuration(hash)
      response = @access_token.post(
        operations_href,
        body: {
          type: "configure",
          env: hash
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      Operation.new(@access_token, response.parsed)
    end

    def remove_from_configuration(keys)
      hash = Hash[ keys.map { |key| [key, ""] } ]
      add_to_configuration(hash)
    end
  end
end
