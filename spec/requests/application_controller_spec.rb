require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  def set_signed_cookie(name, value)
    # Usar el mismo verifier que Rails usa para cookies firmadas
    verifier = Rails.application.message_verifier('signed cookie')
    signed_value = verifier.generate(value)
    cookies[name] = signed_value
  end

  def build_signed_cookie_header(name, value)
    # Usar el mismo verifier que Rails usa para cookies firmadas
    # Rails usa 'signed cookie' como salt por defecto para cookies firmadas
    verifier = Rails.application.message_verifier('signed cookie')
    signed_value = verifier.generate(value)
    # Convertir el nombre de símbolo a string si es necesario
    cookie_name = name.to_s
    # El formato de cookie debe ser: nombre=valor_firmado
    cookie_value = "#{cookie_name}=#{signed_value}"
    { "Cookie" => cookie_value }
  end

  before do
    sign_in user
    I18n.locale = I18n.default_locale
  end

  describe '#check_locale' do
    context 'when no cookie is present' do
      it 'creates a cookie with locale "en"' do
        get root_path

        jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)
        value = jar.signed["_rails_genius_settings"]

        expect(value).to be_present
        expect(value['locale']).to eq('en')
      end

      it 'sets cookie with correct structure' do
        get root_path

        jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)
        value = jar.signed["_rails_genius_settings"]

        expect(value).to be_a(Hash)
        expect(value).to have_key('locale')
        expect(value['locale']).to eq('en')
      end
    end

    context 'when cookie has a valid locale' do
      %w[en es pt].each do |locale|
        it "preserves cookie locale '#{locale}' when it is valid" do
          headers = build_signed_cookie_header(:_rails_genius_settings, { locale: locale })

          get root_path, headers: headers

          expect(I18n.locale).to eq(locale.to_sym)
        end
      end
    end

    context 'when cookie has an invalid locale' do
      it 'updates cookie to "en" when locale is not in allowed list' do
        headers = build_signed_cookie_header(:_rails_genius_settings, { locale: 'fr' })

        get root_path, headers: headers

        expect(I18n.locale).to eq(:en)
      end

      it 'handles invalid locale strings' do
        headers = build_signed_cookie_header(:_rails_genius_settings, { locale: 'invalid' })

        get root_path, headers: headers

        expect(I18n.locale).to eq(:en)
      end
    end

    context 'when cookie exists but has no locale' do
      it 'sets cookie locale to "en" when locale key is missing' do
        headers = build_signed_cookie_header(:_rails_genius_settings, { other_setting: 'value' })

        get root_path, headers: headers

        expect(I18n.locale).to eq(:en)
      end
    end

    context 'when cookie is present but empty' do
      it 'sets cookie locale to "en" when cookie hash is empty' do
        headers = build_signed_cookie_header(:_rails_genius_settings, {})

        get root_path, headers: headers

        expect(I18n.locale).to eq(:en)
      end
    end
  end
end
