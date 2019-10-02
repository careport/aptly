module Aptly
  class Database < Resource
    def_attr :id
    def_attr :handle
    def_attr :type
    def_attr :passphrase
    def_attr :connection_url
    def_attr :status

    def_href :operations

    def provisioned?
      status == "provisioned"
    end

    def provision!(container_size:, disk_size:)
      response = @access_token.post(
        operations_href,
        body: {
          type: "provision",
          container_size: container_size,
          disk_size: disk_size
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      Operation.new(@access_token, response.parsed)
    end

    # Deprovisioning a database also appears to destroy it.
    # However, it appears that the user can reload (or use
    # wait_for_completion on) the Operation returned by this
    # method without worrying about it returning a 404.
    def deprovision!
      response = @access_token.post(
        operations_href,
        body: { type: "deprovision" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      Operation.new(@access_token, response.parsed)
    end

    def restart!(container_size: nil, disk_size: nil)
      response = @access_token.post(
        operations_href,
        body: {
          type: "restart",
          container_size: container_size,
          disk_size: disk_size
        }.compact.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      Operation.new(@access_token, response.parsed)
    end
  end
end
