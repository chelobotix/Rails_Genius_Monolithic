require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:posts).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'devise modules' do
    it 'includes database_authenticatable module' do
      user = build(:user)
      expect(user).to respond_to(:valid_password?)
      expect(user).to respond_to(:encrypted_password)
    end

    it 'includes registerable module' do
      user = build(:user)
      expect(user.new_record?).to be_truthy
      user.save
      expect(user.persisted?).to be_truthy
    end

    it 'includes recoverable module' do
      user = build(:user)
      expect(user).to respond_to(:reset_password_token)
      expect(user).to respond_to(:reset_password_sent_at)
    end

    it 'includes rememberable module' do
      user = build(:user)
      expect(user).to respond_to(:remember_created_at)
    end

    it 'includes validatable module' do
      user = build(:user)
      expect(user).to respond_to(:email)
      expect(user).to respond_to(:password)
    end
  end

  describe 'is_admin attribute' do
    it 'defaults to false' do
      user = create(:user)
      expect(user.is_admin).to be_falsey
    end

    it 'can be set to true' do
      user = create(:user, is_admin: true)
      expect(user.is_admin).to be_truthy
    end
  end

  describe 'email format validation' do
    it 'accepts valid email addresses' do
      user = build(:user, email: 'test@example.com')
      expect(user).to be_valid
    end

    it 'rejects invalid email addresses' do
      user = build(:user, email: 'invalid_email')
      expect(user).not_to be_valid
    end

    it 'rejects email without @ symbol' do
      user = build(:user, email: 'testexample.com')
      expect(user).not_to be_valid
    end
  end

  describe 'password validation' do
    it 'requires password on create' do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user).not_to be_valid
    end

    it 'requires password confirmation when password is present' do
      user = build(:user, password: 'password123', password_confirmation: 'different')
      expect(user).not_to be_valid
    end

    it 'accepts matching password and password_confirmation' do
      user = build(:user, password: 'password123', password_confirmation: 'password123')
      expect(user).to be_valid
    end

    it 'requires minimum password length' do
      user = build(:user, password: 'short', password_confirmation: 'short')
      expect(user).not_to be_valid
    end
  end
end
