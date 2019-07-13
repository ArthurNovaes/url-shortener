module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def url_response(url, status = :ok, user_id = nil)
    hits = url&.hits&.count
    if user_id.present?
      hits = Url.select('urls.id').joins(:hits)
                .where("hits.user_id = #{user_id} AND hits.url_id = #{url.id}").count
    end

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

  def stats_response(user_id = nil)
    stats_response = {
      hits: Hit.count,
      urlCount: Url.count,
      topUrls: top_urls(user_id)
    }

    if user_id.present?
      stats_response[:hits] = Hit.where(user_id: user_id).count.to_i
      stats_response[:urlCount] = Url.select('urls.id')
                                     .joins(:hits)
                                     .where("hits.user_id = #{user_id}").distinct.count
    end

    stats_response
  end

  private

  def top_urls(user_id = nil)
    urls = Url.left_joins(:hits)
    if user_id.present?
      urls = urls.where("hits.user_id = #{user_id}")
    end

    urls = urls.group(:id).order(Arel.sql('COUNT(hits.id) DESC')).limit(10)
    urls = urls.map do |url|
      url_response(url, :ok, user_id)
    end
    urls
  end
end
