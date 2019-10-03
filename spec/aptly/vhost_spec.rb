RSpec.describe Aptly::VHost do
  describe "#id" do
    it "is the id from the JSON data" do
      vhost = Aptly::VHost.new(nil, vhost_data)
      expect(vhost.id).to eq(1)
    end
  end

  describe "#virtual_domain" do
    it "is the virtual domain from the JSON data" do
      vhost = Aptly::VHost.new(nil, vhost_data)
      expect(vhost.virtual_domain).to eq("virtual1.example.com")
    end
  end

  describe "#type" do
    it "is the type from the JSON data" do
      vhost = Aptly::VHost.new(nil, vhost_data)
      expect(vhost.type).to eq("http_proxy_protocol")
    end
  end

  describe "#external_host" do
    it "is the external host from the JSON data" do
      vhost = Aptly::VHost.new(nil, vhost_data)
      expect(vhost.external_host).to eq("external1.example.com")
    end
  end

  describe "#internal_host" do
    it "is the internal host from the JSON data" do
      vhost = Aptly::VHost.new(nil, vhost_data)
      expect(vhost.internal_host).to eq("internal1.example.com")
    end
  end

  describe "#status" do
    it "is the status from the JSON data" do
      vhost = Aptly::VHost.new(nil, vhost_data)
      expect(vhost.status).to eq("pending")
    end
  end

  describe "#default?" do
    it "is true if this is the default vhost" do
      default_vhost = Aptly::VHost.new(nil, vhost_data)
      other_vhost = Aptly::VHost.new(nil, other_vhost_data)
      expect(default_vhost).to be_default
      expect(other_vhost).not_to be_default
    end
  end

  describe "#internal?" do
    it "is true if this is an internal vhost" do
      internal_vhost = Aptly::VHost.new(nil, vhost_data)
      external_vhost = Aptly::VHost.new(nil, other_vhost_data)
      expect(internal_vhost).to be_internal
      expect(external_vhost).not_to be_internal
    end
  end

  describe "#provision!" do
    it "enqueues an Operation to provision the vhost" do
      access_token = fake_operations_token(type: "provision")
      vhost = Aptly::VHost.new(access_token, vhost_data)
      op = vhost.provision!
      expect(op).to be_a(Aptly::Operation)
    end
  end

  describe "#deprovision!" do
    it "enqueues an Operation to deprovision the vhost" do
      access_token = fake_operations_token(type: "deprovision")
      vhost = Aptly::VHost.new(access_token, vhost_data)
      op = vhost.deprovision!
      expect(op).to be_a(Aptly::Operation)
    end
  end

  def fake_operations_token(body)
    instance_double("OAuth::AccessToken").tap do |token|
      allow(token).to receive(:post).with(
        vhost_data.dig("_links", "operations", "href"),
        body: body.to_json,
        headers: { "Content-Type" => "application/json" }
      ).and_return(
        instance_double("OAuth::Response", parsed: JsonFixtures.operations.last)
      )
    end
  end

  def vhost_data
    JsonFixtures.vhosts.first
  end

  def other_vhost_data
    JsonFixtures.vhosts.last
  end

  describe Aptly::VHost::HttpsOptions do
    describe "#to_params" do
      it "is a hash suitable for sending to Aptible" do
        opts = Aptly::VHost::HttpsOptions.new(
          container_port: 443,
          internal: true,
          default: true
        )
        expect(opts.to_params).to eq(
          type: "http",
          platform: "alb",
          ip_whitelist: [],
          container_port: 443,
          internal: true,
          default: true,
          acme: false
        )
      end

      it "sets managed TLS options correctly" do
        opts = Aptly::VHost::HttpsOptions.new(
          managed_tls_domain: "foo.com"
        )
        expect(opts.to_params).to include(
          acme: true,
          user_domain: "foo.com"
        )
      end
    end

    describe "#to_json" do
      it "is a JSON representation of #to_params" do
        opts = Aptly::VHost::HttpsOptions.new(
          container_port: 443,
          internal: true,
          default: true
        )
        params = opts.to_params
        json = opts.to_json
        expect(json).to eq(params.to_json)
      end
    end
  end
end
