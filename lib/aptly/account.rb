module Aptly
  class Account < Resource
    def_attr :id
    def_attr :handle

    def_href :apps
    def_href :databases

    def create_app(handle)
      response = @access_token.post(
        apps_href,
        body: { handle: handle }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      App.new(@access_token, response.parsed)
    end

    def create_db(handle:, database_image:)
      response = @access_token.post(
        databases_href,
        body: {
          handle: handle,
          type: database_image.type,
          database_image: database_image.id
        }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
      Database.new(@access_token, response.parsed)
    end
  end
end
