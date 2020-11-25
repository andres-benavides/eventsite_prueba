class UrlController < ApplicationController
  require 'net/http'

  #crear la url corta
  def short
    alexa_rank = self.alexa_rank params[:url]
    domain = self.get_domain params[:url]
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

  #traer la informacion de alexa
  def alexa_rank url_to_rank
    uri = URI.parse "https://awis.api.alexa.com/api?Action=UrlInfo&ResponseGroup=Rank&Output=json&Url=#{url_to_rank}"
    request = Net::HTTP::Get.new(uri, {
        'Accept' => 'application/json',
        'x-api-key' => "8T7SlYd7Tp16a9VPBovC26LXGhosXjeM97CLbUUv"
    })

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    rta = https.request(request)
    jos = JSON.parse(rta.body)
    jos['Awis']['Results']['Result']['Alexa']['TrafficData']['Rank']
  end

  #obtener el dominio de la url
  def get_domain url
    uri = URI.parse url
    host = uri.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

  #retornar los dominios registrados
  def domains
    render json: Url.select(:domain).distinct, each_serializer: DomainsSerializer, root: false
  end

  def get_by_domain
    render json: Url.where("domain LIKE :dom", {:dom => "%#{params[:domain]}%"})
  end

end