# frozen_string_literal: true

# Тестирование действий над записями документов, удостоверяющих личность

RSpec.describe Cab::Actions::Documents do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:update) }
  end

  describe '.update' do
    subject(:result) { described_class.update(params) }

    let(:params) { { id: id, content: content } }
    let(:id) { document.id }
    let(:document) { create(:identity_document) }
    let(:content) { create(:string) }
    let(:file) { Cab::Models::File.with_pk(document.file_id) }

    it 'shouldn\'t update `created_at` field' do
      expect { subject }.not_to change { document.reload.created_at }
    end

    it 'should update content of the document\'s file' do
      subject
      expect(file.reload.content).to be == content
    end

    context 'when params is of String type' do
      context 'when params is a JSON-string' do
        context 'when params represents a map' do
          context 'when the map is of wrong structure' do
            let(:params) { Oj.dump(wrong: :structure) }

            it 'should raise JSON::Schema::ValidationError' do
              expect { subject }.to raise_error(JSON::Schema::ValidationError)
            end
          end
        end

        context 'when params does not represent a map' do
          let(:params) { Oj.dump(%i[not a map]) }

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

    context 'when params is of Hash type' do
      context 'when params is of wrong structure' do
        let(:params) { { wrong: :structure } }

        it 'should raise JSON::Schema::ValidationError' do
          expect { subject }.to raise_error(JSON::Schema::ValidationError)
        end
      end
    end

    context 'when params is not of Hash type nor of String type' do
      let(:params) { %w[not of Hash type nor of String type] }

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
