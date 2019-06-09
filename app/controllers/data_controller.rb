require 'elasticsearch'
class DataController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :raw

  def raw
    data = JSON.parse request.body.read
    bulk = data.map do |d|
      {
        index: {
          _index: 'raw',
          _type: '_doc',
          data: d
        }
      }
    end
    client = Elasticsearch::Client.new log: true, url: ENV['ELASTICSEARCH_URL']
    client.bulk body: bulk

    head :ok
  end

  def map
    client = Elasticsearch::Client.new log: true, url: ENV['ELASTICSEARCH_URL']
    data = client.search index: 'raw', body: {
      size: 10000,
      query: {
        bool: {
          must: [
            {
              range: {
                magnitude: {
                  gte: 2
                }
              }
            },
            {
              exists: {
                field: 'latitude'
              }
            },
            {
              exists: {
                field: 'longitude'
              }
            },
            {
              range: {
                time: {
                  gte: 1560096000000,
                  lte: 1560097800000
                }
              }
            }
          ]
        }
      }
    }
    @heatmap = data['hits']['hits'].map do |d|
      s = d['_source']
      {
        lat: s['latitude'],
        lng: s['longitude'],
        magnitude: s['magnitude']
      }
    end
  end
end
