module Aptly
  class VHost < Resource
    def_attr :id
    def_attr :virtual_domain
    def_attr :type
    def_attr :external_host
    def_attr :internal_host
    def_attr :status
    def_attr :default
    def_attr :internal

    def_href :operations

    def default?
      default == "true"
    end

    def internal?
      internal == "true"
    end

    def provision!
      response = @access_token.post(
        operations_href,
        body: { type: "provision" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      Operation.new(@access_token, response.parsed)
    end

    # If you wait_for_completion on the returned Operation,
    # be prepared to handle a 404 error, which is an indication
    # of success.
    def deprovision!
      response = @access_token.post(
        operations_href,
        body: { type: "deprovision" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      Operation.new(@access_token, response.parsed)
    end

    # This code does not handle explicitly provided TLS certs.
    # They can be added later if we need them.
    class HttpsOptions
      def initialize(
          ip_whitelist: [],
          container_port: nil,
          internal: false,
          default: false,
          managed_tls_domain: nil
        )
        @ip_whitelist = ip_whitelist
        @container_port = container_port
        @internal = internal
        @default = default
        @managed_tls_domain = managed_tls_domain
      end

      def to_params
        {
          type: "http",
          platform: "alb",
          ip_whitelist: @ip_whitelist,
          container_port: @container_port,
          internal: !!@internal,
          default: !!@default,
          acme: !!@managed_tls_domain,
          user_domain: @managed_tls_domain
        }.compact
      end

      def to_json(*)
        to_params.to_json
      end
    end
  end
end
