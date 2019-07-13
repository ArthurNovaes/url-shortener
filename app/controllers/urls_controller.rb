class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :destroy]

  def show
    user = User.find_by(login: user_params[:login])
    user_id = user&.id

    create_hit(@url.id, user_id)
    redirect_to @url.sanitize, status: :moved_permanently
  end

  def destroy
    @url.destroy
    head :no_content
  end

  def create
    @url = Url.new
    @url.original = url_params
    @url.short = generate_short
    @url.sanitize = sanitize(url_params)
    existing = find_duplicate(@url.sanitize)
    unless existing
      return json_response(url_response(@url, :created), :created) if @url.save
    end

    json_response(url_response(existing, :found), :found)
  end


  private

  def user_params
    params.permit(:login)
  end

  def url_params
    params.require(:url)
  end

  def set_url
    @url = Url.find(params[:id])
  end

  def create_hit(url_id, user_id = nil)
    Hit.create!(url_id: url_id, user_id: user_id)
  end

  def generate_short
    url = ([*('a'..'z'),*('0'..'9')]).sample(6).join
    old = Url.find_by(short: url)
    return 'EXISTS' if old.present?

    url
  end

  def sanitize(original_url)
    original_url.strip
    sanitize = original_url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
    sanitize = "http://#{sanitize}"
  end

  def find_duplicate(sanitized_url)
    Url.find_by(sanitize: sanitized_url)
  end
end
