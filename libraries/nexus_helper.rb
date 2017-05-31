require 'open-uri'
require 'timeout'

module Nexus3
  # Helper library for testing Nexus3 responses
  module Helper
    class Nexus3Timeout < Timeout::Error; end

    # Raise an error in case Nexus takes a really long time to start.
    class Nexus3NotReady < StandardError
      def initialize(endpoint, timeout)
        super <<-EOH
The Nexus server at #{endpoint} did not become ready within #{timeout}
seconds. On large Nexus instances (or on smaller hardware), you may need
to increase the timeout to #{timeout * 4} seconds. Alternatively, Nexus
may have failed to start.
EOH
      end
    end

    def self.wait_until_ready!(url)
      nexus_timeout = 15 * 60
      Timeout.timeout(nexus_timeout, Nexus3Timeout) do
        begin
          open(url)
        rescue SocketError,
               Errno::ECONNREFUSED,
               Errno::ECONNRESET,
               Errno::ENETUNREACH,
               OpenURI::HTTPError => e
          # Getting 403 is ok since it means we reached the endpoint and
          # it's asking us for authentication.
          return if e.message =~ /^403/
          Chef::Log.debug("Nexus3 is not accepting requests - #{e.message}")
          sleep 1
          retry
        end
      end
    rescue Nexus3Timeout
      raise Nexus3NotReady.new(endpoint, nexus_timeout)
    end
  end
end