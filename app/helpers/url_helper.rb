module UrlHelper

  #traer la informacion de alexa
  def alexa_rank url_to_rank
    uri = URI.parse "https://awis.api.alexa.com/api?Action=UrlInfo&ResponseGroup=Rank&Output=json&Url=#{url_to_rank}"
    request = Net::HTTP::Get.new(uri, {
        'Accept' => 'application/json',
        'x-api-key' => "8T7SlYd7Tp16a9VPBovC26LXGhosXjeM97CLbUUv"
    })
    begin
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.read_timeout = 10

      rta = https.request(request)
      jos = JSON.parse(rta.body)
      if jos['Awis']['Results']['Result']['Alexa']['TrafficData'].nil?
        "Rank not found"
      else
        jos['Awis']['Results']['Result']['Alexa']['TrafficData']['Rank']

      end
    rescue => e
      p "Error al consumir API de Alexa #{e.message}"
      "Rank not found - timeout"
    end
  end

  #obtener el dominio de la url
  def get_domain url
    uri = URI.parse url
    host = uri.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end
end