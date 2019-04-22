RSpec.describe Aptly::Operation do
  describe "#id" do
    it "is the id from the JSON data" do
      operation = Aptly::Operation.new(nil, operation_data)
      expect(operation.id).to eq(1)
    end
  end

  describe "#status" do
    it "is the status from the JSON data" do
      operation = Aptly::Operation.new(nil, operation_data)
      expect(operation.status).to eq("running")
    end
  end

  describe "#wait_for_completion" do
    it "polls the API until the operation has finished" do
      ClimateControl.modify(APTLY_POLL_INTERVAL: "0.0001") do
        token = fake_access_token
        operation = Aptly::Operation.new(token, operation_data)
        operation.wait_for_completion
        expect(operation).to be_succeeded
        expect(token).to have_received(:get).exactly(3).times
      end
    end
  end

  def operation_data
    {
      "id" => 1,
      "status" => "running",
      "_links" => {
        "self" => {
          "href" => "https://example.com/services/123/operations/1"
        }
      }
    }
  end

  def fake_access_token
    url = operation_data.dig("_links", "self", "href")
    instance_double("OAuth2::AccessToken").tap do |token|
      allow(token).to receive(:get).with(url).and_return(
        instance_double("OAuth::Response", parsed: operation_data),
        instance_double("OAuth::Response", parsed: operation_data),
        instance_double(
          "OAuth::Response",
          parsed: operation_data.merge("status" => "succeeded")
        )
      )
    end
  end
end
