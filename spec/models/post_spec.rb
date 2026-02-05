require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title_en) }
    it { should validate_presence_of(:title_es) }
    it { should validate_presence_of(:title_pt) }
    it { should validate_presence_of(:description_en) }
    it { should validate_presence_of(:description_es) }
    it { should validate_presence_of(:description_pt) }
    it { should validate_presence_of(:body_en) }
    it { should validate_presence_of(:body_es) }
    it { should validate_presence_of(:body_pt) }
    it { should validate_presence_of(:words) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'AASM state machine' do
    let(:user) { create(:user) }
    let(:post) do
      build(:post,
        user: user,
        title_en: 'Test Title',
        title_es: 'Título de Prueba',
        title_pt: 'Título de Teste',
        description_en: 'Test Description',
        description_es: 'Descripción de Prueba',
        description_pt: 'Descrição de Teste',
        body_en: 'Test Body',
        body_es: 'Cuerpo de Prueba',
        body_pt: 'Corpo de Teste',
        words: 100,
        year: 2025)
    end

    context 'initial state' do
      it 'starts in draft state' do
        post.save!
        expect(post.draft?).to be_truthy
        expect(post.status).to eq('draft')
      end
    end

    context 'publish event' do
      it 'transitions from draft to published' do
        post.save!
        post.publish

        expect(post.published?).to be_truthy
        expect(post.draft?).to be_falsey
        expect(post.status).to eq('published')
      end

      it 'does not transition from published state' do
        post.save!
        post.publish

        expect { post.publish }.to raise_error(AASM::InvalidTransition)
        expect(post.published?).to be_truthy
        expect(post.status).to eq('published')
      end
    end

    context 'archive event' do
      it 'transitions from published to archived' do
        post.save
        post.publish
        post.archive

        expect(post.archived?).to be_truthy
        expect(post.published?).to be_falsey
        expect(post.status).to eq('archived')
      end

      it 'does not transition from draft state' do
        post.save
        initial_status = post.status

        expect { post.archive }.to raise_error(AASM::InvalidTransition)

        expect(post.draft?).to be_truthy
        expect(post.status).to eq(initial_status)
      end
    end

    context 'unpublish event' do
      it 'transitions from published to draft' do
        post.save
        post.publish
        post.unpublish

        expect(post.draft?).to be_truthy
        expect(post.published?).to be_falsey
        expect(post.status).to eq('draft')
      end

      it 'does not transition from draft state' do
        post.save
        initial_status = post.status

        expect { post.unpublish }.to raise_error(AASM::InvalidTransition)

        expect(post.draft?).to be_truthy
        expect(post.status).to eq(initial_status)
      end
    end

    context 'unarchive event' do
      it 'transitions from archived to published' do
        post.save
        post.publish
        post.archive
        post.unarchive

        expect(post.published?).to be_truthy
        expect(post.archived?).to be_falsey
        expect(post.status).to eq('published')
      end

      it 'does not transition from draft state' do
        post.save
        initial_status = post.status

        expect { post.unarchive }.to raise_error(AASM::InvalidTransition)

        expect(post.draft?).to be_truthy
        expect(post.status).to eq(initial_status)
      end
    end
  end
end
