require 'elasticsearch'
class DataController < ApplicationController
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

    render :nothing
  end
end
