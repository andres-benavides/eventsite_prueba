class UrlController < ApplicationController
  require 'net/http'
  include UrlHelper


  #crear la url corta
  def short
    alexa_rank = alexa_rank params[:url]
    domain = get_domain params[:url]
    @url = Url.create url: params[:url], alexa_rank: alexa_rank, domain: domain
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

end