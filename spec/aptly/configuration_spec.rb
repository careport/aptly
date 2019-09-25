RSpec.describe Aptly::Configuration do
  describe "#id" do
    it "is the id from the JSON data" do
      config = Aptly::Configuration.new(nil, configuration_data)
      expect(config.id).to eq(100)
    end
  end

  describe "#env" do
    it "is the env from the JSON data" do
      config = Aptly::Configuration.new(nil, configuration_data)
      expect(config.env).to eq(
        "VAR1" => "hello",
        "VAR2" => "goodbye"
      )
    end
  end

  def configuration_data
    {
      "id" => 100,
      "env" => {
        "VAR1" => "hello",
        "VAR2" => "goodbye"
      }
    }
  end
end
