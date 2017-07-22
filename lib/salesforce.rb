require 'net/http'
require 'uri'

module Salesforce
  module Api
    VERSIONS_ENDPOINT = "/services/data/"
    AUTH_ENDPOINT = "/services/oauth2/token"
    QUERY_ENDPOINT = "/services/data/v20.0/query/"

    class Client
      attr_reader :host
      attr_reader :auth

      def initialize(host)
        @host = host
      end

      def authenticate(params)
        res = Net::HTTP.post_form(URI.join(host, AUTH_ENDPOINT), {
          "grant_type": 'password'
        }.merge(params))

        @auth = JSON.parse(res.body)

        raise AuthenticationError.new(@auth["error"]) if @auth["error"]

        self
      end

      def query(q)
        get(QUERY_ENDPOINT, { q: q })
      end

      def get(path, params = {})
        uri = URI.join(auth["instance_url"], path)
        uri.query = URI.encode_www_form(params)

        req = Net::HTTP::Get.new(uri.request_uri)
        req['Authorization'] = [auth['token_type'], auth['access_token']].join(" ")
        req["Accept"] = "*/*"

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        res = http.request(req)

        Response.new(res.body, self)
      end
    end

    class Response
      attr_reader :response
      attr_reader :client

      def initialize(response, client)
        @response = response
        @client = client
      end

      def body
        @body ||= JSON.parse(response)
      end

      def next
        if !body["done"] && body["nextRecordsUrl"]
          client.get(body["nextRecordsUrl"])
        end
      end
    end

    class AuthenticationError < StandardError; end
  end
end
