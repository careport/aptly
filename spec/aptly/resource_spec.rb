RSpec.describe Aptly::Resource do
  describe "#href" do
    it "is the resource's URL" do
      resource = resource_klass.new(nil, resource_data)
      expect(resource.href).
        to eq("https://api.example.com/resources/123")
    end
  end

  describe "#reload" do
    it "reloads the resource" do
      access_token = instance_double("OAuth::AccessToken")
      allow(access_token).to receive(:get).
        with("https://api.example.com/resources/123").
        and_return(fake_oauth_response)

      resource = resource_klass.new(access_token, resource_data)
      resource.reload
      expect(resource.id).to eq(124)
    end
  end

  def resource_klass
    Class.new(Aptly::Resource) do
      def_attr :id
    end
  end

  def resource_data
    {
      "id" => 123,
      "_links" => {
        "self" => {
          "href" => "https://api.example.com/resources/123"
        }
      }
    }
  end

  def fake_oauth_response
    instance_double(
      "OAuth2::Response",
      parsed: resource_data.merge("id" => 124)
    )
  end
end
