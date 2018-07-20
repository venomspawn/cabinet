# frozen_string_literal: true

# Тестирование действий над записями документов, удостоверяющих личность

RSpec.describe Cab::Actions::Documents do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:update) }
  end

  describe '.update' do
    subject(:result) { described_class.update(params, rest) }

    let(:rest) { nil }
    let(:params) { data }
    let(:data) { { id: id, content: content } }
    let(:id) { document.id }
    let(:document) { create(:identity_document) }
    let(:content) { create(:string) }
    let(:file) { Cab::Models::File.with_pk(document.file_id) }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    it 'shouldn\'t update `created_at` field' do
      expect { subject }.not_to change { document.reload.created_at }
    end

    it 'should update content of the document\'s file' do
      subject
      expect(file.reload.content).to be == content
    end
  end
end
