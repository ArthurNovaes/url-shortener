class StatsController < ApplicationController

  def show
    url = Url.find(params[:id])

    json_response(url_response(url))
  end
end
