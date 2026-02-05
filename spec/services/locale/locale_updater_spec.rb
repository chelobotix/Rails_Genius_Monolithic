require 'rails_helper'

RSpec.describe Locale::LocaleUpdater, type: :service do
  describe '#call' do
    let(:settings) { {} }
    let(:locale) { 'en' }


    before do
      # Reset I18n locale before each test
      I18n.locale = I18n.default_locale
    end

    context 'when locale and settings are valid' do
      it 'sets the locale successfully' do
        service = described_class.new(settings: {}, locale: 'en')
        service.call

        expect(service.valid?).to be_truthy
        expect(I18n.locale).to eq(:en)
        expect(service.errors).to be_nil
      end

      context 'with different valid locales' do
        %w[en es pt].each do |valid_locale|
          it "sets locale to #{valid_locale}" do
            service = described_class.new(settings: {}, locale: valid_locale)
            service.call

            expect(I18n.locale).to eq(valid_locale.to_sym)
            expect(service.valid?).to be true
          end
        end
      end

      context 'with valid settings hash' do
        let(:settings) { { key: 'value' } }

        it 'processes successfully' do
          service = described_class.new(settings: {}, locale: 'en')
          service.call

          expect(service.valid?).to be true
          expect(I18n.locale).to eq(:en)
        end
      end

      context 'with nil settings' do
        let(:settings) { nil }

        it 'processes successfully' do
          service = described_class.new(settings: {}, locale: 'en')
          service.call

          expect(service.valid?).to be true
          expect(I18n.locale).to eq(:en)
        end
      end
    end

    context 'when locale is invalid' do
      let(:locale) { 'fr' }

      it 'return invalid with error' do
        service = described_class.new(settings: {}, locale: locale)
        service.call

        expect(service.valid?).to be_falsey
        expect(service.errors[:code]).to eq(1001)
      end

      context 'with empty string locale' do
        let(:locale) { '' }

        it 'return invalid with error when locale is empty' do
          service = described_class.new(settings: {}, locale: locale)
          service.call

          expect(service.valid?).to be_falsey
          expect(service.errors[:code]).to eq(1001)
        end
      end

      context 'with nil locale' do
        let(:locale) { nil }

        it 'return invalid with error when locale is nil' do
          service = described_class.new(settings: {}, locale: locale)
          service.call

          expect(service.valid?).to be_falsey
          expect(service.errors[:code]).to eq(1001)
        end
      end
    end

    context 'when settings is invalid' do
      let(:settings) { 'invalid_string' }

      it 'return invalid with error when settings is invalid' do
        service = described_class.new(settings: settings, locale: 'en')
        service.call

        expect(service.valid?).to be_falsey
        expect(service.errors[:code]).to eq(1000)
      end
    end

    context 'when both locale and settings are invalid' do
      let(:settings) { 'invalid' }
      let(:locale) { 'fr' }

      it 'return invalid with error when settings is invalid' do
        service = described_class.new(settings: settings, locale: locale)
        service.call

        expect(service.valid?).to be_falsey
        expect(service.errors[:code]).to eq(1000)
      end
    end

    context 'idempotency' do
      it 'can be called multiple times with same result' do
        service = described_class.new(settings: settings, locale: locale)
        service.call

        first_locale = I18n.locale
        first_valid = service.valid?

        # Reset locale
        I18n.locale = I18n.default_locale
        service2 = described_class.new(settings: settings, locale: locale)
        service2.call

        expect(I18n.locale).to eq(first_locale)
        expect(service2.valid?).to eq(first_valid)
      end
    end
  end
end
