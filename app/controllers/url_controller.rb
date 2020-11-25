class UrlController < ApplicationController
  require 'net/http'
  include UrlHelper

  before_action :auth_user

  #crear la url corta
  def short
    alexa_rank = alexa_rank params[:url]
    host = get_domain params[:url]
    host = host.split "."
    domain = host.count >= 3 ? host[host.count - 2] :  host[host.count - 1]
    @url = @user.url.create url: params[:url], alexa_rank: alexa_rank, domain: domain
    @url.save!
    render json: {url_short: @url.url_short}
  end

  #enviar a la url original
  def redirect
    @url = Url.find_by_short_code params[:short_code]
    @url.update_attribute(:counter, @url.counter + 1)
    redirect_to @url.url
  end

  #retornar los dominios registrados
  def domains
    render json: Url.select(:domain).distinct, each_serializer: DomainsSerializer, root: false
  end

  def get_by_domain
    render json: Url.where("domain LIKE :dom", {:dom => "%#{params[:domain]}%"})
  end

  private
  def auth_user
    t_regx = /Bearer (\w+)/
    headers = request.headers

    if headers['Authorization'].present? && headers['Authorization'].match(t_regx)
      token =  headers['Authorization'].match(t_regx)[1]
      @user = User.find_by_auth_token token
    elsif request.method == "GET"
      false
    else
      render json:{error:"unathotization"}, status: :unauthorized
    end

  end

end