require 'rails_helper'

RSpec.describe LocalesController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  def build_signed_cookie_header(name, value)
    verifier = Rails.application.message_verifier('signed cookie')
    signed_value = verifier.generate(value)

    cookie_name = name.to_s
    cookie_value = "#{cookie_name}=#{signed_value}"
    { "Cookie" => cookie_value }
  end

  before do
    sign_in user
    I18n.locale = I18n.default_locale
  end

  describe 'POST #updater' do
    context 'when service is valid' do
      context 'with valid locale' do
        %w[en es pt].each do |locale|
          it "updates locale to #{locale} successfully" do
            headers = build_signed_cookie_header(:_rails_genius_settings, {})
            post updater_locales_path, params: { locale: locale }, headers: headers

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)['message']).to eq('Locale updated successfully')
            expect(I18n.locale).to eq(locale.to_sym)

            jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)
            cookie_value = jar.signed["_rails_genius_settings"]
            expect(cookie_value['locale']).to eq(locale)
          end
        end
      end

      context 'with existing settings cookie' do
        it 'preserves existing settings and updates locale' do
          existing_settings = { key: 'value', other: 'data' }
          headers = build_signed_cookie_header(:_rails_genius_settings, existing_settings)

          post updater_locales_path, params: { locale: 'es' }, headers: headers

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['message']).to eq('Locale updated successfully')

          jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)
          cookie_value = jar.signed["_rails_genius_settings"]
          expect(cookie_value['locale']).to eq('es')
          expect(cookie_value['key']).to eq('value')
          expect(cookie_value['other']).to eq('data')
        end
      end

      context 'with nil settings cookie' do
        it 'creates new cookie with locale' do
          post updater_locales_path, params: { locale: 'pt' }

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['message']).to eq('Locale updated successfully')

          jar = ActionDispatch::Cookies::CookieJar.build(request, response.cookies)
          cookie_value = jar.signed["_rails_genius_settings"]
          expect(cookie_value['locale']).to eq('pt')
        end
      end
    end

    context 'when service is invalid' do
      context 'with invalid locale' do
        it 'returns bad_request with error code' do
          headers = build_signed_cookie_header(:_rails_genius_settings, {})
          post updater_locales_path, params: { locale: 'fr' }, headers: headers

          expect(response).to have_http_status(:bad_request)
          response_body = JSON.parse(response.body)
          expect(response_body['message']['code']).to eq(1001)
        end
      end

      context 'with empty locale' do
        it 'returns bad_request with error code' do
          headers = build_signed_cookie_header(:_rails_genius_settings, {})
          post updater_locales_path, params: { locale: '' }, headers: headers

          expect(response).to have_http_status(:bad_request)
          response_body = JSON.parse(response.body)
          expect(response_body['message']['code']).to eq(1001)
        end
      end

      context 'with nil locale' do
        it 'returns bad_request with error code' do
          headers = build_signed_cookie_header(:_rails_genius_settings, {})
          post updater_locales_path, params: { locale: nil }, headers: headers

          expect(response).to have_http_status(:bad_request)
          response_body = JSON.parse(response.body)
          expect(response_body['message']['code']).to eq(1001)
        end
      end

      context 'with invalid settings cookie' do
        it 'returns bad_request with error code' do
          headers = build_signed_cookie_header(:_rails_genius_settings, 'invalid_string')
          post updater_locales_path, params: { locale: 'en' }, headers: headers

          expect(response).to have_http_status(:bad_request)
          response_body = JSON.parse(response.body)
          expect(response_body['message']['code']).to eq(1000)
        end
      end
    end
  end
end
