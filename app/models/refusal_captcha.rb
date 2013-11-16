class RefusalCaptcha < NegativeCaptcha
  def valid?
    return true if defined? ENV and ENV["RAILS_ENV"].downcase == 'test'
    super
  end
end