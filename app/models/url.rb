class Url < ApplicationRecord

  belongs_to :user

  validates_uniqueness_of :short_code
  validates :url, format: URI::regexp(%w[http https])

  before_validation :generate_short_code
  before_save :default_counter

  #poner el counter en 0 la primera vez
  def default_counter
    self.counter = 0 if self.counter.nil?
  end


  def generate_short_code
    self.short_code = SecureRandom.uuid[0..5] if self.short_code.nil? || self.short_code.empty?
    true
  end

  #NUEVO ENLACE CORTO
  def url_short
    Rails.application.routes.url_helpers.short_url(short_code: self.short_code)
  end

  #redireccionar y contar la visita a la url
  def counter_url
    self.update_attribute(:counter, self.counter + 1)
  end





end
