module Aptly
  class Account < Resource
    def_attr :id
    def_attr :handle

    def_href :apps

    def create_app(handle)
      response = @access_token.post(
        apps_href,
        body: { handle: handle }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      App.new(@access_token, response.parsed)
    end
  end
end
