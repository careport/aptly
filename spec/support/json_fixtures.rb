module JsonFixtures
  def self.apps(first_id: 1)
    [
      {
        "id" => first_id,
        "handle" => "app-1",
        "_embedded" => {
          "services" => services(first_id: 100)
        },
        "_links" => {
          "operations" => {
            "href" => "https://example.com/apps/1/operations"
          },
          "current_configuration" => {
            "href" => "https://example.com/apps/1/current_configuration"
          }
        }
      },
      {
        "id" => first_id + 1,
        "handle" => "app-2",
        "_embedded" => {
          "services" => services(first_id: 200)
        },
        "_links" => {
          "operations" => {
            "href" => "https://example.com/apps/2/operations"
          },
          "current_configuration" => {
            "href" => "https://example.com/apps/2/current_configuration"
          }
        }
      }
    ]
  end

  def self.accounts(first_id: 1)
    [
      {
        "id" => first_id,
        "handle" => "dev",
        "_links" => {
          "apps" => {
            "href" => "https://example.com/accounts/1/apps"
          }
        }
      },
      {
        "id" => first_id + 1,
        "handle" => "prod",
        "_links" => {
          "apps" => {
            "href" => "https://example.com/accounts/2/apps"
          }
        }
      }
    ]
  end

  def self.database_images(first_id: 1)
    [
      {
        "id" => first_id,
        "type" => "postgresql",
        "version" => "11",
        "description" => "PostgreSQL 11"
      },
      {
        "id" => first_id + 1,
        "type" => "elasticsearch",
        "version" => "6",
        "description" => "ElasticSearch 6"
      }
    ]
  end

  def self.databases(first_id: 1)
    [
      {
        "id" => first_id,
        "handle" => "my-db",
        "type" => "postgresql",
        "passphrase" => "opensesame",
        "connection_url" => "postgresql://aptible:opensesame@db-foobar-1234.aptible.in:20807/db",
        "status" => "provisioned",
        "_links" => {
          "self" => {
            "href" => "https://example.com/databases/1"
          },
          "operations" => {
            "href" => "https://example.com/databases/1/operations"
          }
        }
      },
      {
        "id" => first_id + 1,
        "handle" => "your-db",
        "type" => "elasticsearch",
        "passphrase" => "12345",
        "connection_url" => "elasticsearch://foo/db",
        "status" => "pending",
        "_links" => {
          "self" => {
            "href" => "https://example.com/databases/2"
          },
          "operations" => {
            "href" => "https://example.com/databases/2/operations"
          }
        }
      }
    ]
  end

  def self.services(first_id: 1)
    [
      {
        "id" => first_id,
        "handle" => "foo",
        "process_type" => "web",
        "container_count" => 2,
        "container_memory_limit_mb" => 1024,
        "_links" => {
          "operations" => {
            "href" => "https://example.com/services/1/operations"
          },
          "vhosts" => {
            "href" => "https://example.com/services/1/vhosts"
          }
        }
      },
      {
        "id" => first_id + 1,
        "handle" => "bar",
        "process_type" => "non-web",
        "container_count" => 1,
        "container_memory_limit_mb" => 2048,
        "_links" => {
          "operations" => {
            "href" => "https://example.com/services/2/operations"
          },
          "vhosts" => {
            "href" => "https://example.com/services/2/vhosts"
          }
        }
      }
    ]
  end

  def self.operations
    [
      {
        "id" => 1,
        "status" => "running",
        "_links" => {
          "self" => {
            "href" => "https://example.com/services/123/operations/1"
          }
        }
      },
      {
        "id" => 2,
        "status" => "queued",
        "_links" => {
          "self" => {
            "href" => "https://example.com/services/123/operations/2"
          }
        }
      }
    ]
  end

  def self.configurations
    [
      {
        "id" => 100,
        "env" => {
          "VAR1" => "hello",
          "VAR2" => "goodbye"
        }
      }
    ]
  end

  def self.vhosts
    [
      {
        "id" => 1,
        "virtual_domain" => "virtual1.example.com",
        "type" => "http_proxy_protocol",
        "external_host" => "external1.example.com",
        "internal_host" => "internal1.example.com",
        "status" => "pending",
        "default" => "true",
        "internal" => "true",
        "_links" => {
          "operations" => {
            "href" => "https://example.com/vhosts/1/operations"
          }
        }
      },
      {
        "id" => 2,
        "virtual_domain" => "virtual2.example.com",
        "type" => "http_proxy_protocol",
        "external_host" => "external2.example.com",
        "internal_host" => "internal2.example.com",
        "status" => "provisioned",
        "default" => "false",
        "internal" => "false",
        "_links" => {
          "operations" => {
            "href" => "https://example.com/vhosts/2/operations"
          }
        }
      }
    ]
  end
end
