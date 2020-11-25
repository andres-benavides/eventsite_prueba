class UrlSerializer < ActiveModel::Serializer
  attributes :url,:short_code,:alexa_rank,:counter

  def short_code
    url.url_short
  end


  private
  def url
    self.object
  end
end
