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

  describe "#services" do
    it "is an array of this app's services" do
      app = Aptly::App.new(nil, app_data)
      expect(app.services).to be_a(Array)
      expect(app.services).to all(be_a(Aptly::Service))
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
      }
    }
  end
end
