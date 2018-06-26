# frozen_string_literal: true

# Тестирование действий над записями документов, удостоверяющих личность

RSpec.describe Cab::Actions::Documents do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:update) }
  end

  describe '.update' do
    include described_class::Update::SpecHelper

    subject(:result) { described_class.update(id, params) }

    let(:id) { document.id }
    let(:document) { create(:identity_document) }
    let(:params) { create('params/actions/documents/update', traits) }
    let(:traits) { {} }

    describe 'result' do
      subject { result }

      it { is_expected.to match_json_schema(schema) }
    end

    it 'shouldn\'t update `created_at` field' do
      expect { subject }.not_to change { document.reload.created_at }
    end

    it 'should update content of the document' do
      subject
      document.reload
      expect(document.content).to be == params.first[:content]
    end

    context 'when there is `id` property in params' do
      let(:traits) { :with_id }

      it 'should ignore it' do
        expect { subject }.not_to change { document.reload.id }
      end
    end

    context 'when there is additional property in params' do
      let(:params) { [content: document.content, additional: :property] }

      it 'should ignore it' do
        expect { subject }.not_to change { document.reload.values }
      end
    end

    context 'when params is of String type' do
      context 'when params is a JSON-string' do
        context 'when params represents a list' do
          context 'when the list is of wrong structure' do
            let(:params) { Oj.dump(%i[of wrong structure]) }

            it 'should raise JSON::Schema::ValidationError' do
              expect { subject }.to raise_error(JSON::Schema::ValidationError)
            end
          end
        end

        context 'when params does not represent a list' do
          let(:params) { Oj.dump(not: { a: :list}) }

          it 'should raise JSON::Schema::ValidationError' do
            expect { subject }.to raise_error(JSON::Schema::ValidationError)
          end
        end
      end

      context 'when params is not a JSON-string' do
        let(:params) { 'not a JSON-string' }

        it 'should raise Oj::ParseError' do
          expect { subject }.to raise_error(Oj::ParseError)
        end
      end
    end

    context 'when params is of Array type' do
      context 'when params is of wrong structure' do
        let(:params) { %i[of wrong structure] }

        it 'should raise JSON::Schema::ValidationError' do
          expect { subject }.to raise_error(JSON::Schema::ValidationError)
        end
      end
    end

    context 'when params is not of Array type nor of String type' do
      let(:params) { { wrong: :type } }

      it 'should raise JSON::Schema::ValidationError' do
        expect { subject }.to raise_error(JSON::Schema::ValidationError)
      end
    end

    context 'when the record can\'t be found' do
      let(:id) { create(:uuid) }

      it 'should raise Sequel::NoMatchingRow' do
        expect { subject }.to raise_error(Sequel::NoMatchingRow)
      end
    end
  end
end
