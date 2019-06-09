class DataController < ApplicationController
  def raw
    puts request.body.read
    render :nothing
  end
end
