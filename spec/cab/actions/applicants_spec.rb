# frozen_string_literal: true

# Тестирование действий над записями заявителей

RSpec.describe Cab::Actions::Applicants do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:create, :lookup, :show, :update) }
  end

  describe '.create' do
    include described_class::Create::SpecHelper

    subject(:result) { described_class.create(params) }

    describe 'result' do
      subject { result }

      context 'when creating a record of individual' do
        let(:params) { { individual: data } }
        let(:data) { create('params/actions/individuals/create') }

        it { is_expected.to match_json_schema(schema) }
      end

      context 'when creating a record of entrepreneur' do
        let(:params) { { entrepreneur: data } }
        let(:data) { create('params/actions/entrepreneurs/create', *traits) }
        let(:traits) { %i[with_individual] }

        it { is_expected.to match_json_schema(schema) }
      end

      context 'when creating a record of organization' do
        let(:params) { { organization: data } }
        let(:data) { create('params/actions/organizations/create') }

        it { is_expected.to match_json_schema(schema) }
      end
    end

    context 'when creating a record of individual' do
      let(:params) { { individual: data } }
      let(:data) { create('params/actions/individuals/create') }

      it 'should call `create` function of Cab::Actions::Individuals' do
        expect(Cab::Actions::Individuals).to receive(:create)
        subject
      end
    end

    context 'when creating a record of entrepreneur' do
      let(:params) { { entrepreneur: data } }
      let(:data) { create('params/actions/entrepreneurs/create', *traits) }
      let(:traits) { %i[with_individual] }

      it 'should call `create` function of Cab::Actions::Entrepreneurs' do
        expect(Cab::Actions::Entrepreneurs).to receive(:create)
        subject
      end
    end

    context 'when creating a record of organization' do
      let(:params) { { organization: data } }
      let(:data) { create('params/actions/organizations/create') }

      it 'should call `create` function of Cab::Actions::Organizations' do
        expect(Cab::Actions::Organizations).to receive(:create)
        subject
      end
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
          let(:params) { Oj.dump(%w[not a map]) }

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
  end

  describe '.lookup' do
    include described_class::Lookup::SpecHelper

    subject(:result) { described_class.lookup(params) }

    describe 'result' do
      subject { result }

      context 'when looking for individuals' do
        let(:params) { { individual: { first_name: first_name } } }
        let(:first_name) { create(:string) }
        let!(:exact) { create_list(:individual, 2, name: first_name) }
        let!(:other) { create_list(:individual, 2) }

        it { is_expected.to match_json_schema(schema) }
      end

      context 'when looking for entrepreneurs' do
        let(:params) { { entrepreneur: { first_name: first_name } } }
        let(:first_name) { create(:string) }
        let!(:exact) { create_entrepreneurs(2, name: first_name) }
        let!(:other) { create_entrepreneurs(2) }

        it { is_expected.to match_json_schema(schema) }
      end

      context 'when looking for organizations' do
        let(:params) { { organization: { full_name: full_name } } }
        let(:full_name) { create(:string) }
        let!(:exact) { create_list(:organization, 2, full_name: full_name) }
        let!(:other) { create_list(:organization, 2) }

        it { is_expected.to match_json_schema(schema) }
      end
    end

    context 'when looking for individuals' do
      let(:params) { { individual: { first_name: first_name } } }
      let(:first_name) { create(:string) }
      let!(:exact) { create_list(:individual, 2, name: first_name) }
      let!(:other) { create_list(:individual, 2) }

      it 'should call `lookup` function of Cab::Actions::Individuals' do
        expect(Cab::Actions::Individuals).to receive(:lookup)
        subject
      end
    end

    context 'when looking for entrepreneurs' do
      let(:params) { { entrepreneur: { first_name: first_name } } }
      let(:first_name) { create(:string) }
      let!(:exact) { create_entrepreneurs(2, name: first_name) }
      let!(:other) { create_entrepreneurs(2) }

      it 'should call `lookup` function of Cab::Actions::Entrepreneurs' do
        expect(Cab::Actions::Entrepreneurs).to receive(:lookup)
        subject
      end
    end

    context 'when looking for organizations' do
      let(:params) { { organization: { full_name: full_name } } }
      let(:full_name) { create(:string) }
      let!(:exact) { create_list(:organization, 2, full_name: full_name) }
      let!(:other) { create_list(:organization, 2) }

      it 'should call `lookup` function of Cab::Actions::Organizations' do
        expect(Cab::Actions::Organizations).to receive(:lookup)
        subject
      end
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
          let(:params) { Oj.dump(%w[not a map]) }

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
  end

  describe '.show' do
    include described_class::Show::SpecHelper

    subject(:result) { described_class.show(params) }

    describe 'result' do
      subject { result }

      let(:params) { { id: id, extended: extended } }
      let(:id) { record.id }

      context 'when looking for a record of individual' do
        let(:record) { create(:individual) }
        let!(:identity_documents) { create_list(:identity_document, 2, args) }
        let(:args) { { individual_id: id } }
        let(:extended) { false }

        context 'when `extended` is boolean false' do
          let(:extended) { false }

          it { is_expected.to match_json_schema(schema) }

          it 'shouldn\'t include information about consent to processing' do
            expect(result).not_to include(:consent_to_processing)
          end

          it 'shouldn\'t include information about identity documents' do
            expect(result).not_to include(:identity_documents)
          end
        end

        context 'when `extended` is the string `false`' do
          let(:extended) { 'false' }

          it { is_expected.to match_json_schema(schema) }

          it 'shouldn\'t include information about consent to processing' do
            expect(result).not_to include(:consent_to_processing)
          end

          it 'shouldn\'t include information about identity documents' do
            expect(result).not_to include(:identity_documents)
          end
        end

        context 'when `extended` isn\'t string `false` nor boolean false' do
          let(:extended) { 'not the string `false` nor boolean false' }

          it { is_expected.to match_json_schema(schema) }

          it 'should include information about consent to processing' do
            expect(result).to include(:consent_to_processing)
          end

          it 'should include information about identity documents' do
            expect(result).to include(:identity_documents)
          end
        end
      end

      context 'when looking for a record of entrepreneur' do
        let(:record) { create(:entrepreneur) }
        let!(:identity_documents) { create_list(:identity_document, 2, args) }
        let(:args) { { individual_id: record.individual_id } }
        let(:extended) { false }

        context 'when `extended` is boolean false' do
          let(:extended) { false }

          it { is_expected.to match_json_schema(schema) }

          it 'shouldn\'t include information about consent to processing' do
            expect(result).not_to include(:consent_to_processing)
          end

          it 'shouldn\'t include information about identity documents' do
            expect(result).not_to include(:identity_documents)
          end
        end

        context 'when `extended` is the string `false`' do
          let(:extended) { 'false' }

          it { is_expected.to match_json_schema(schema) }

          it 'shouldn\'t include information about consent to processing' do
            expect(result).not_to include(:consent_to_processing)
          end

          it 'shouldn\'t include information about identity documents' do
            expect(result).not_to include(:identity_documents)
          end
        end

        context 'when `extended` isn\'t string `false` nor boolean false' do
          let(:extended) { 'not the string `false` nor boolean false' }

          it { is_expected.to match_json_schema(schema) }

          it 'should include information about consent to processing' do
            expect(result).to include(:consent_to_processing)
          end

          it 'should include information about identity documents' do
            expect(result).to include(:identity_documents)
          end
        end
      end

      context 'when looking for a record of entrepreneur' do
        let(:record) { create(:organization) }
        let(:extended) { nil }

        it { is_expected.to match_json_schema(schema) }
      end
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
          let(:params) { Oj.dump(%w[not a map]) }

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
      let(:params) { { id: create(:uuid) } }

      it 'should raise Sequel::NoMatchingRow' do
        expect { subject }.to raise_error(Sequel::NoMatchingRow)
      end
    end
  end

  describe '.update' do
    include described_class::Update::SpecHelper

    subject(:result) { described_class.update(id, params) }

    let(:id) { record.id }
    let(:record) { create(:individual) }

    describe 'result' do
      subject { result }

      context 'when updating a record of individual' do
        let(:record) { create(:individual) }
        let(:params) { { individual: data } }
        let(:data) { create('params/actions/individuals/update') }

        it { is_expected.to match_json_schema(schema) }
      end

      context 'when updating a record of entrepreneur' do
        let(:record) { create(:entrepreneur) }
        let(:params) { { entrepreneur: data } }
        let(:data) { create('params/actions/entrepreneurs/update') }

        it { is_expected.to match_json_schema(schema) }
      end

      context 'when updating a record of organization' do
        let(:record) { create(:organization) }
        let(:params) { { organization: data } }
        let(:data) { create('params/actions/organizations/update') }

        it { is_expected.to match_json_schema(schema) }
      end
    end

    context 'when updating a record of individual' do
      let(:record) { create(:individual) }
      let(:params) { { individual: data } }
      let(:data) { create('params/actions/individuals/update') }

      it 'should call `update` function of Cab::Actions::Individuals' do
        expect(Cab::Actions::Individuals).to receive(:update)
        subject
      end

      context 'when the record isn\'t found' do
        let(:id) { create(:uuid) }

        it 'should raise Sequel::NoMatchingRow' do
          expect { subject }.to raise_error(Sequel::NoMatchingRow)
        end
      end
    end

    context 'when updating a record of entrepreneur' do
      let(:record) { create(:entrepreneur) }
      let(:params) { { entrepreneur: data } }
      let(:data) { create('params/actions/entrepreneurs/update') }

      it 'should call `update` function of Cab::Actions::Entrepreneurs' do
        expect(Cab::Actions::Entrepreneurs).to receive(:update)
        subject
      end

      context 'when the record isn\'t found' do
        let(:id) { create(:uuid) }

        it 'should raise Sequel::NoMatchingRow' do
          expect { subject }.to raise_error(Sequel::NoMatchingRow)
        end
      end
    end

    context 'when updating a record of organization' do
      let(:record) { create(:organization) }
      let(:params) { { organization: data } }
      let(:data) { create('params/actions/organizations/update') }

      it 'should call `update` function of Cab::Actions::Organizations' do
        expect(Cab::Actions::Organizations).to receive(:update)
        subject
      end

      context 'when the record isn\'t found' do
        let(:id) { create(:uuid) }

        it 'should raise Sequel::NoMatchingRow' do
          expect { subject }.to raise_error(Sequel::NoMatchingRow)
        end
      end
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
          let(:params) { Oj.dump(%w[not a map]) }

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
  end
end
