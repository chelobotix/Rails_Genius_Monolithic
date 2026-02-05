class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Pundit::Authorization
  include CookieManager

  before_action :authenticate_user!
  before_action :check_locale

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def check_locale
    allowed_locales = %w[en es pt]
    settings = cookies.signed[:_rails_genius_settings]

    if settings.is_a?(Hash) && settings.dig("locale").present? && allowed_locales.include?(settings["locale"])
      I18n.locale = settings["locale"].to_sym
    else
      settings = {}
      I18n.locale = :en
      set_locale_cookie(settings, "en")
    end
  end
end
