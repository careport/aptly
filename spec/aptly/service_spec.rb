RSpec.describe Aptly::Service do
  describe "#id" do
    it "is the id from the JSON data" do
      service = Aptly::Service.new(nil, service_data)
      expect(service.id).to eq(1)
    end
  end

  describe "#handle" do
    it "is the handle from the JSON data" do
      service = Aptly::Service.new(nil, service_data)
      expect(service.handle).to eq("foo")
    end
  end

  describe "#process_type" do
    it "is the process type from the JSON data" do
      service = Aptly::Service.new(nil, service_data)
      expect(service.process_type).to eq("web")
    end
  end

  describe "#container_count" do
    it "is the container count from the JSON data" do
      service = Aptly::Service.new(nil, service_data)
      expect(service.container_count).to eq(2)
    end
  end

  describe "#container_memory_limit_mb" do
    it "is the container memory limit from the JSON data" do
      service = Aptly::Service.new(nil, service_data)
      expect(service.container_memory_limit_mb).to eq(1024)
    end
  end

  describe "#operations_href" do
    it "is the operations href from the JSON data" do
      service = Aptly::Service.new(nil, service_data)
      expect(service.operations_href).
        to eq("https://example.com/services/1/operations")
    end
  end

  describe "scale" do
    it "enqueues an Operation to scale the container count and/or memory limit" do
      service = Aptly::Service.new(fake_access_token, service_data)
      operation = service.scale(container_count: 4)
      expect(operation).to be_a(Aptly::Operation)
      expect(operation).to be_queued
    end
  end

  def service_data
    {
      "id" => 1,
      "handle" => "foo",
      "process_type" => "web",
      "container_count" => 2,
      "container_memory_limit_mb" => 1024,
      "_links" => {
        "operations" => {
          "href" => "https://example.com/services/1/operations"
        }
      }
    }
  end

  def fake_access_token
    instance_double("OAuth::AccessToken").tap do |token|
      allow(token).to receive(:post).with(
        "https://example.com/services/1/operations",
        body: {
          type: "scale",
          container_count: 4
        }.to_json,
        headers: {
          "Content-Type" => "application/json"
        }
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
end
