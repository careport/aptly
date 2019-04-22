module Aptly
  class Operation < Resource
    def_attr :id
    def_attr :status

    def succeeded?
      status == "succeeded"
    end

    def failed?
      status == "failed"
    end

    def queued?
      status == "queued"
    end

    def running?
      status == "running"
    end

    def completed?
      succeeded? || failed?
    end

    def wait_for_completion
      while !completed?
        sleep(poll_interval)
        reload
      end
    end

    def poll_interval
      ENV.fetch("APTLY_POLL_INTERVAL", 3).to_f
    end
  end
end
