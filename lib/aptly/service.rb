module Aptly
  class Service < Resource
    def_attr :id
    def_attr :handle
    def_attr :process_type
    def_attr :container_count
    def_attr :container_memory_limit_mb

    def_href :operations
    def_href :vhosts

    def scale(container_count: nil, container_memory_limit_mb: nil)
      params = {
        type: "scale",
        container_count: container_count,
        container_size: container_memory_limit_mb
      }.compact

      response = @access_token.post(
        operations_href,
        body: params.to_json,
        headers: {
          "Content-Type" => "application/json"
        }
      )
      Operation.new(@access_token, response.parsed)
    end

    def vhosts
      @access_token.get(vhosts_href).parsed.
        dig("_embedded", "vhosts").
        map { |vhost_data| VHost.new(@access_token, vhost_data) }
    end

    def create_https_vhost(https_options)
      response = @access_token.post(
        vhosts_href,
        body: https_options.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      VHost.new(@access_token, response.parsed)
    end
  end
end
