module Locale
  class LocaleUpdater
    include BaseService

    attr_reader :locale
    private attr_reader :settings

    ALLOWED_LOCALES = %w[en es pt].freeze
    private_constant :ALLOWED_LOCALES

    def initialize(settings:, locale:)
      @settings = settings
      @locale = locale
    end

    def call
      perform
      set_as_valid!

    rescue ::Errors::StandardServiceError => e
      set_errors({ service: self.class, error_code: e.code, error_details: e.details })
      set_as_invalid!
    end

    private

    def perform
      validate_settings
      validate_locale
      set_locale
    end

    def validate_settings
      if settings.present? && !settings.is_a?(Hash)
        raise ::Errors::StandardServiceError.new(
          message: "Invalid settings",
          code: 1000, details: "Invalid settings")
      end
    end

    def validate_locale
      if locale.present? && ALLOWED_LOCALES.exclude?(locale)
        raise ::Errors::StandardServiceError.new(
          message: "Invalid locale",
          code: 1000, details: "Invalid locale")
      end
    end

    def set_locale
      ::I18n.locale = locale.to_sym
    end
  end
end
