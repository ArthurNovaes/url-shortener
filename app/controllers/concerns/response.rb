module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def url_response(url, status = :ok)
    hits = Hit.where(url_id: url.id)&.count
    host = request.host_with_port
    result = {
      id: url.id,
      hits: hits.to_i,
      url: url.original,
      shortUrl: host + '/' + url.short
    }

    if status == :found
      result[:message] = 'This url already exists'
    end

    result
  end
end
