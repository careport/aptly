module RequestStubs
  def stub_valid_token_request(email, password)
    stub_request(:post, "https://auth.aptible.com/tokens").with(
      body: {
        "client_id" => nil,
        "client_secret" => nil,
        "grant_type" => "password",
        "password" => password,
        "scope" => "manage",
        "username" => email
      }
    ).to_return(
      status: 200,
      body: {
        "id" => "11111111-2222-3333-4444-555555555555",
        "token_type" => "bearer",
        "expires_in" => 604699,
        "scope" => "manage",
        "_type" => "token",
        "created_at" => Time.now.iso8601(3),
        "expires_at" => (Time.now + 604699).iso8601(3),
        "access_token" => "TOKEN"
      }.to_json,
      headers: {
        "Content-Type" => "application/json"
      }
    )
  end

  def stub_invalid_token_request(email, password)
    stub_request(:post, "https://auth.aptible.com/tokens").with(
      body: {
        "client_id" => nil,
        "client_secret" => nil,
        "grant_type" => "password",
        "password" => password,
        "scope" => "manage",
        "username" => email
      }
    ).to_return(
      status: 401,
      body: {
        "code" => 401,
        "error" => "invalid_credentials",
        "message" => "Invalid password",
        "exception_content" => {}
      }.to_json,
      headers: {
        "Content-Type" => "application/json"
      }
    )
  end

  def stub_valid_app_request(app_id)
    stub_request(:get, "https://api.aptible.com/apps/#{app_id}").with(
      headers: {
        "Authorization"=>"Bearer TOKEN",
      }).to_return(
        status: 200,
        body: {
          "id" => app_id,
          "handle" => "fake-app",
          "_embedded" => {
            "services" => [
              {
                "id" => 100,
                "process_type" => "web",
              },
              {
                "id" => 200,
                "process_type" => "fake_service",
              },
              {
                "id" => 100,
                "process_type" => "blah",
              }
            ]
          }
        }.to_json,
        headers: {
          "Content-Type" => "application/hal+json"
        }
      )
  end

  def stub_invalid_app_request(app_id)
    stub_request(:get, "https://api.aptible.com/apps/#{app_id}").with(
      headers: {
        "Authorization"=>"Bearer TOKEN",
      }).to_return(
        status: 404,
        body: {
        "code" => 404,
        "error" => "not_found",
        "message" => "Not Found"
        }.to_json,
        headers: {
          "Content-Type" => "application/json"
        }
      )
  end
end
