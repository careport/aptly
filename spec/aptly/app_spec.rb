RSpec.describe Aptly::App do
  describe "#id" do
    it "is the app's id from the JSON data" do
      app = Aptly::App.new(nil, app_data)
      expect(app.id).to eq(666)
    end
  end

  describe "#handle" do
    it "is the app's handle from the JSON data" do
      app = Aptly::App.new(nil, app_data)
      expect(app.handle).to eq("fake-app")
    end
  end

  describe "#operations_href" do
    it "is the operations href from the JSON data" do
      app = Aptly::App.new(nil, app_data)
      expect(app.operations_href).to eq("https://example.com/apps/666/operations")
    end
  end

  describe "#current_configuration_href" do
    it "is the operations href from the JSON data" do
      app = Aptly::App.new(nil, app_data)
      expect(app.current_configuration_href).
        to eq("https://example.com/apps/666/current_configuration")
    end
  end

  describe "#services" do
    it "is an array of this app's services" do
      app = Aptly::App.new(nil, app_data)
      expect(app.services).to be_a(Array)
      expect(app.services).to all(be_a(Aptly::Service))
    end
  end

  describe "#deprovision!" do
    it "enqueues an Operation to deprovision the app" do
      access_token = fake_operations_access_token(type: "deprovision")
      app = Aptly::App.new(access_token, app_data)
      operation = app.deprovision!
      expect(operation).to be_a(Aptly::Operation)
      expect(operation).to be_queued
    end
  end

  describe "#current_configuration" do
    it "returns the app's current Configuration" do
      app = Aptly::App.new(fake_configuration_access_token, app_data)
      config = app.current_configuration
      expect(config).to be_a(Aptly::Configuration)
      expect(config.id).to eq(1234)
      expect(config.env).to eq(
        "FOO" => "123",
        "BAR" => "abc"
      )
    end
  end

  describe "#add_to_configuration" do
    it "enqueues an Operation to add the given pairs to the configuration" do
      env = { "hello" => "goodbye" }
      access_token = fake_operations_access_token(type: "configure", env: env)
      app = Aptly::App.new(access_token, app_data)
      operation = app.add_to_configuration(env)
      expect(operation).to be_a(Aptly::Operation)
      expect(operation).to be_queued
    end
  end

  describe "#remove_from_configuration" do
    it "calls add_to_configuration with empty string values" do
      app = Aptly::App.new(nil, app_data)
      allow(app).to receive(:add_to_configuration)
      app.remove_from_configuration(["hello"])
      expect(app).to have_received(:add_to_configuration).with("hello" => "")
    end
  end

  def app_data
    {
      "id" => 666,
      "handle" => "fake-app",
      "_embedded" => {
        "services" => [
          {
            "id" => "1",
            "handle" => "foo",
            "process_type" => "web"
          },
          {
            "id" => "2",
            "handle" => "bar",
            "process_type" => "sidekiq default worker"
          }
        ]
      },
      "_links" => {
        "operations" => {
          "href" => "https://example.com/apps/666/operations"
        },
        "current_configuration" => {
          "href" => "https://example.com/apps/666/current_configuration"
        }
      }
    }
  end

  def fake_operations_access_token(body)
    instance_double("OAuth::AccessToken").tap do |token|
      allow(token).to receive(:post).with(
        app_data.dig("_links", "operations", "href"),
        body: body.to_json,
        headers: { "Content-Type" => "application/json" }
      ).and_return(
        instance_double("OAuth::Response", parsed: fake_operation_data)
      )
    end
  end

  def fake_operation_data
    {
      "id" => 100,
      "status" => "queued"
    }
  end

  def fake_configuration_access_token
    instance_double("OAuth::AccessToken").tap do |token|
      allow(token).to receive(:get).with(
        app_data.dig("_links", "current_configuration", "href")
      ).and_return(
        instance_double("OAuth::Response", parsed: fake_configuration_data)
      )
    end
  end

  def fake_configuration_data
    {
      "id" => 1234,
      "env" => {
        "FOO" => "123",
        "BAR" => "abc"
      }
    }
  end
end
