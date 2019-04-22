module Aptly
  class Service < Resource
    def_attr :id
    def_attr :handle
    def_attr :process_type
    def_attr :container_count
    def_attr :container_memory_limit_mb
    def_attr :operations_href, "_links", "operations", "href"

    def scale(container_count: nil, container_memory_limit_mb: nil)
      params = {
        container_count: container_count,
        container_size: container_memory_limit_mb
      }.compact

      response = @access_token.post(operations_href, params)
      Operation.new(@access_token, response.parsed)
    end
  end
end
