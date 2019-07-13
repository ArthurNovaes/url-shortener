class StatsController < ApplicationController

  def show
    url = Url.find(params[:id])

    json_response(url_response(url))
  end

  def index
    json_response(stats_response)
  end
end
