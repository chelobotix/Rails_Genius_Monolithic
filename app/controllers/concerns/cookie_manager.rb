module CookieManager
  extend ActiveSupport::Concern

  included do
    helper_method :set_locale_cookie
  end

  def set_locale_cookie(settings, value)
    if settings.present?
      cookie_value = { **settings.to_h, "locale" => value }
    else
      cookie_value = { "locale" => value }
    end

    cookies.signed[:_rails_genius_settings] = {
      value: cookie_value,
      expires: 1.year.from_now,
      secure: Rails.env.production?,
      same_site: :strict,
      httponly: false
    }
  end
end
