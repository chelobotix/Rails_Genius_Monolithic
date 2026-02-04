class LocalesController < ApplicationController
  include CookieManager

  def updater
    settings = cookies.signed[:_rails_genius_settings]

    service = ::Locale::LocaleUpdater.call(settings: settings, locale: params[:locale])

    if service.valid?
      set_locale_cookie(settings, params[:locale])

      render json: { message: "Locale updated successfully" }, status: :ok
    else
      render json: { message: service.errors }, status: :bad_request
    end
  end
end
