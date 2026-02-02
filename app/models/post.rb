class Post < ApplicationRecord
  extend Mobility

  # TRANSLATIONS
  translates :title, type: :string, locale_accessors: [ :en, :es, :pt ]
  translates :description, type: :string, locale_accessors: [ :en, :es, :pt ]
  translates :body, type: :text, locale_accessors: [ :en, :es, :pt ]

  # ASSOCIATIONS
  belongs_to :user

  # VALIDATIONS
  validates :title_en, presence: true
  validates :title_es, presence: true
  validates :title_pt, presence: true
  validates :description_en, presence: true
  validates :description_es, presence: true
  validates :description_pt, presence: true
  validates :body_en, presence: true
  validates :body_es, presence: true
  validates :body_pt, presence: true
  validates :words, presence: true
  validates :year, presence: true
  validates :user_id, presence: true
end
