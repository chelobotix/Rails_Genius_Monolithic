class Post < ApplicationRecord
  extend Mobility
  include AASM

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

  # AASM STATE MACHINE
  aasm column: :status do
    state :draft, initial: true
    state :published
    state :archived

    event :publish do
      transitions from: :draft, to: :published
    end

    event :archive do
      transitions from: :published, to: :archived
    end

    event :unpublish do
      transitions from: :published, to: :draft
    end

    event :unarchive do
      transitions from: :archived, to: :published
    end
  end
end
