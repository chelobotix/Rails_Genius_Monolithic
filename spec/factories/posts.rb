FactoryBot.define do
  factory :post do
    association :user
    title_en { 'Test Title' }
    title_es { 'Título de Prueba' }
    title_pt { 'Título de Teste' }
    description_en { 'Test Description' }
    description_es { 'Descripción de Prueba' }
    description_pt { 'Descrição de Teste' }
    body_en { 'Test Body' }
    body_es { 'Cuerpo de Prueba' }
    body_pt { 'Corpo de Teste' }
    words { 100 }
    year { 2025 }
    status { 'draft' }

    trait :published do
      status { 'published' }
    end

    trait :archived do
      status { 'archived' }
    end
  end
end
