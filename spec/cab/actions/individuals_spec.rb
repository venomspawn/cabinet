# frozen_string_literal: true

# Тестирование действий над записями физических лиц

RSpec.describe Cab::Actions::Individuals do
  describe 'the module' do
    subject { described_class }

    names = %i[
      create
      create_vicarious_authority
      lookup
      show
      update
      update_personal_info
    ]
    it { is_expected.to respond_to(*names) }
  end

  describe '.create' do
    include described_class::Create::SpecHelper

    subject(:result) { described_class.create(params) }

    let(:params) { create('params/actions/individuals/create', *traits) }
    let(:traits) { [] }

    describe 'result' do
      subject { result }

      it { is_expected.to match_json_schema(schema) }
    end

    it 'should create a record of the individual' do
      expect { subject }.to change { Cab::Models::Individual.count }.by(1)
    end

    it 'should create a record of identity document of the individual' do
      expect { subject }
        .to change { Cab::Models::IdentityDocument.count }
        .by(1)
    end

    context 'when file of agreement isn\'t found' do
      let(:traits) { [agreement_id: create(:uuid)] }

      it 'should raise Sequel::ForeignKeyConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
      end

      it 'shouldn\'t create records' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::Individual.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::IdentityDocument.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::VicariousAuthority.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::IndividualSpokesman.count }
          .by(0)
      end
    end

    context 'when file of agreement belongs to other individual record' do
      let(:traits) { [agreement_id: agreement_id] }
      let(:agreement_id) { other_individual.agreement_id }
      let!(:other_individual) { create(:individual) }

      it 'should raise Sequel::UniqueConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
      end

      it 'shouldn\'t create records' do
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::Individual.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::IdentityDocument.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::VicariousAuthority.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::IndividualSpokesman.count }
          .by(0)
      end
    end

    context 'when file of identity document isn\'t found' do
      let(:traits) { [identity_document: doc] }
      let(:doc) { create('params/identity_document', file_id: file_id) }
      let(:file_id) { create(:uuid) }

      it 'should raise Sequel::ForeignKeyConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
      end

      it 'shouldn\'t create records' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::Individual.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::IdentityDocument.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::VicariousAuthority.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::IndividualSpokesman.count }
          .by(0)
      end
    end

    context 'when file of identity document belongs to other document' do
      let(:traits) { [identity_document: doc] }
      let(:doc) { create('params/identity_document', file_id: file_id) }
      let(:file_id) { other_document.file_id }
      let!(:other_document) { create(:identity_document) }

      it 'should raise Sequel::UniqueConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
      end

      it 'shouldn\'t create records' do
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::Individual.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::IdentityDocument.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::VicariousAuthority.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::IndividualSpokesman.count }
          .by(0)
      end
    end

    context 'when there is information about spokesman' do
      let(:traits) { %i[with_spokesman] }

      it 'should create a record of vicarious authority' do
        expect { subject }
          .to change { Cab::Models::VicariousAuthority.count }
          .by(1)
      end

      it 'should create a record of link between individual and spokesman' do
        expect { subject }
          .to change { Cab::Models::IndividualSpokesman.count }
          .by(1)
      end

      context 'when the record of spokesman isn\'t found' do
        let(:traits) { [:with_spokesman, spokesman: spokesman] }
        let(:spokesman) { create('params/spokesman', id: create(:uuid)) }

        it 'should raise Sequel::NoMatchingRow' do
          expect { subject }.to raise_error(Sequel::NoMatchingRow)
        end

        it 'shouldn\'t create records' do
          expect { subject }
            .to raise_error(Sequel::NoMatchingRow)
            .and change { Cab::Models::Individual.count }
            .by(0)
          expect { subject }
            .to raise_error(Sequel::NoMatchingRow)
            .and change { Cab::Models::IdentityDocument.count }
            .by(0)
          expect { subject }
            .to raise_error(Sequel::NoMatchingRow)
            .and change { Cab::Models::VicariousAuthority.count }
            .by(0)
          expect { subject }
            .to raise_error(Sequel::NoMatchingRow)
            .and change { Cab::Models::IndividualSpokesman.count }
            .by(0)
        end
      end

      context 'when file of vicarious authority isn\'t found' do
        let(:traits) { [:with_spokesman, spokesman: spokesman] }
        let!(:spokesman) { create('params/spokesman', file_id: file_id) }
        let(:file_id) { create(:uuid) }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end

        it 'shouldn\'t create records' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
            .and change { Cab::Models::Individual.count }
            .by(0)
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
            .and change { Cab::Models::IdentityDocument.count }
            .by(0)
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
            .and change { Cab::Models::VicariousAuthority.count }
            .by(0)
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
            .and change { Cab::Models::IndividualSpokesman.count }
            .by(0)
        end
      end

      context 'when file of vicarious authority belongs to other record' do
        let(:traits) { [:with_spokesman, spokesman: spokesman] }
        let(:args) { { spokesman: spokesman } }
        let!(:spokesman) { create('params/spokesman', file_id: file_id) }
        let(:file_id) { other_vicarious_authority.file_id }
        let(:other_vicarious_authority) { create(:vicarious_authority) }

        it 'should raise Sequel::UniqueConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::UniqueConstraintViolation)
        end

        it 'shouldn\'t create records' do
          expect { subject }
            .to raise_error(Sequel::UniqueConstraintViolation)
            .and change { Cab::Models::Individual.count }
            .by(0)
          expect { subject }
            .to raise_error(Sequel::UniqueConstraintViolation)
            .and change { Cab::Models::IdentityDocument.count }
            .by(0)
          expect { subject }
            .to raise_error(Sequel::UniqueConstraintViolation)
            .and change { Cab::Models::VicariousAuthority.count }
            .by(0)
          expect { subject }
            .to raise_error(Sequel::UniqueConstraintViolation)
            .and change { Cab::Models::IndividualSpokesman.count }
            .by(0)
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

  describe '.create_vicarious_authority' do
    subject(:result) { described_class.create_vicarious_authority(id, params) }

    let(:id) { record.id }
    let(:record) { create(:individual) }
    let(:factory) { 'params/actions/individuals/create_vicarious_authority' }
    let(:params) { create(factory, traits) }
    let(:traits) { {} }

    it 'should create a record of vicarious authority' do
      expect { subject }
        .to change { Cab::Models::VicariousAuthority.count }
        .by(1)
    end

    it 'should create a record of link between individual and spokesman' do
      expect { subject }
        .to change { Cab::Models::IndividualSpokesman.count }
        .by(1)
    end

    context 'when the record of individual isn\'t found' do
      let(:id) { create(:uuid) }

      it 'should raise Sequel::NoMatchingRow' do
        expect { subject }.to raise_error(Sequel::NoMatchingRow)
      end

      it 'shouldn\'t create records' do
        expect { subject }
          .to raise_error(Sequel::NoMatchingRow)
          .and change { Cab::Models::VicariousAuthority.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::NoMatchingRow)
          .and change { Cab::Models::IndividualSpokesman.count }
          .by(0)
      end
    end

    context 'when the record of spokesman isn\'t found' do
      let(:traits) { { spokesman_id: create(:uuid) } }

      it 'should raise Sequel::NoMatchingRow' do
        expect { subject }.to raise_error(Sequel::NoMatchingRow)
      end

      it 'shouldn\'t create records' do
        expect { subject }
          .to raise_error(Sequel::NoMatchingRow)
          .and change { Cab::Models::VicariousAuthority.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::NoMatchingRow)
          .and change { Cab::Models::IndividualSpokesman.count }
          .by(0)
      end
    end

    context 'when file isn\'t found' do
      let(:traits) { { file_id: create(:uuid) } }

      it 'should raise Sequel::ForeignKeyConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
      end

      it 'shouldn\'t create records' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::VicariousAuthority.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::EntrepreneurSpokesman.count }
          .by(0)
      end
    end

    context 'when file belongs to other vicarious authority' do
      let(:traits) { { file_id: file_id } }
      let(:file_id) { other_vicarious_authority.file_id }
      let!(:other_vicarious_authority) { create(:vicarious_authority) }

      it 'should raise Sequel::UniqueConstraintViolation' do
        expect { subject }.to raise_error(Sequel::UniqueConstraintViolation)
      end

      it 'shouldn\'t create records' do
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::VicariousAuthority.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::EntrepreneurSpokesman.count }
          .by(0)
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

      context 'when there are exact matches' do
        let(:params) { { first_name: first_name } }
        let(:first_name) { create(:string) }
        let(:limit) { described_class::Lookup::LIMIT }
        let!(:exact) { create_list(:individual, limit + 1, name: first_name) }
        let!(:other) { create_list(:individual, 2) }

        it { is_expected.to match_json_schema(schema) }

        it 'should have the matched info in `exact` property' do
          expect(ids(subject[:exact]) - exact.map(&:id)).to be_empty
        end

        it 'shouldn\'t have more elements in the property than limited' do
          expect(result[:exact].size).to be <= limit
        end

        it 'should have `fuzzy` property empty' do
          expect(result[:fuzzy]).to be_empty
        end

        context 'when `last_name` param is blank' do
          it 'should have `without_last_name` property empty' do
            expect(result[:without_last_name]).to be_empty
          end
        end

        context 'when `last_name` param isn\'t blank' do
          let(:params) { { first_name: first_name, last_name: last_name } }
          let(:last_name) { create(:string) }

          context 'when there are exact matches excluding surname' do
            let!(:ones) { create_list(:individual, limit + 1, one_traits) }
            let(:one_traits) { { name: first_name, surname: create(:string) } }
            let!(:exact) { create_list(:individual, limit + 1, exact_traits) }
            let(:exact_traits) { { name: first_name, surname: last_name } }

            it 'should have the matched info in `without_last_info`' do
              expect(ids(subject[:without_last_name]) - ones.map(&:id))
                .to be_empty
            end

            it 'shouldn\'t have more elements in the property than limited' do
              expect(result[:without_last_name].size).to be <= limit
            end
          end
        end
      end

      context 'when there aren\'t exact matches' do
        let(:params) { { first_name: first_name } }
        let(:first_name) { create(:string) }
        let(:limit) { described_class::Lookup::LIMIT }
        let!(:other) { create_list(:individual, 2) }

        it { is_expected.to match_json_schema(schema) }

        it 'should have `exact` property empty' do
          expect(result[:exact]).to be_empty
        end

        context 'when `last_name` param is blank' do
          it 'should have `without_last_name` property empty' do
            expect(result[:without_last_name]).to be_empty
          end
        end

        context 'when `last_name` param isn\'t blank' do
          let(:params) { { first_name: first_name, last_name: last_name } }
          let(:last_name) { create(:string) }

          context 'when there are exact matches excluding surname' do
            let!(:ones) { create_list(:individual, limit + 1, one_traits) }
            let(:one_traits) { { name: first_name, surname: create(:string) } }

            it 'should have the matched info in `without_last_info`' do
              expect(ids(subject[:without_last_name]) - ones.map(&:id))
                .to be_empty
            end

            it 'shouldn\'t have more elements in the property than limited' do
              expect(result[:without_last_name].size).to be <= limit
            end
          end
        end

        context 'when there are fuzzy matches' do
          let!(:fuzzy) { create_list(:individual, limit + 1, fuzzy_traits) }
          let(:fuzzy_traits) { { name: fuzzy_first_name } }
          let(:fuzzy_first_name) { "#{first_name}f" }

          it 'should have the matched info in `fuzzy`' do
            expect(ids(subject[:fuzzy]) - fuzzy.map(&:id)).to be_empty
          end

          it 'shouldn\'t have more elements in the property than limited' do
            expect(result[:fuzzy].size).to be <= limit
          end
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

  describe '.show' do
    include described_class::Show::SpecHelper

    subject(:result) { described_class.show(params) }

    describe 'result' do
      subject { result }

      let(:params) { { id: id, extended: extended } }
      let(:id) { individual.id }
      let(:individual) { create(:individual) }
      let!(:identity_documents) { create_list(:identity_document, 2, traits) }
      let(:traits) { { individual_id: id } }

      context 'when `extended` is boolean false' do
        let(:extended) { false }

        it { is_expected.to match_json_schema(schema) }

        it 'shouldn\'t include information about consent to processing' do
          expect(result).not_to include(:agreement_id)
        end

        it 'shouldn\'t include information about identity documents' do
          expect(result).not_to include(:identity_documents)
        end
      end

      context 'when `extended` is the string `false`' do
        let(:extended) { 'false' }

        it { is_expected.to match_json_schema(schema) }

        it 'shouldn\'t include information about consent to processing' do
          expect(result).not_to include(:agreement_id)
        end

        it 'shouldn\'t include information about identity documents' do
          expect(result).not_to include(:identity_documents)
        end
      end

      context 'when `extended` isn\'t the string `false` nor boolean false' do
        let(:extended) { 'not the string `false` nor boolean false' }

        it { is_expected.to match_json_schema(schema) }

        it 'should include information about consent to processing' do
          expect(result).to include(:agreement_id)
        end

        it 'should include information about identity documents' do
          expect(result).to include(:identity_documents)
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

    context 'when the record can\'t be found' do
      let(:params) { { id: create(:uuid) } }

      it 'should raise Sequel::NoMatchingRow' do
        expect { subject }.to raise_error(Sequel::NoMatchingRow)
      end
    end
  end

  describe '.update' do
    subject(:result) { described_class.update(id, params) }

    let(:id) { individual.id }
    let(:individual) { create(:individual) }
    let(:params) { create('params/actions/individuals/update') }

    it 'shouldn\'t update `created_at` field' do
      expect { subject }.not_to change { individual.reload.created_at }
    end

    it 'should update fields of the record' do
      subject
      individual.reload

      expect(individual.snils).to be == params[:snils]
      expect(individual.inn).to be == params[:inn]

      expect(individual.registration_address.to_hash.symbolize_keys)
        .to be == params[:registration_address]

      expect(individual.residence_address.to_hash.symbolize_keys)
        .to be == params[:residential_address]
    end

    context 'when there is `id` property in params' do
      let(:params) { create('params/actions/individuals/update', traits) }
      let(:traits) { { id: new_id } }
      let(:new_id) { create(:uuid) }

      it 'should ignore it' do
        expect { subject }.not_to change { individual.reload.id }
      end
    end

    context 'when there is additional property in params' do
      let(:params) { { additional: :property } }

      it 'should ignore it' do
        expect { subject }.not_to change { individual.reload.values }
      end
    end

    context 'when params is of String type' do
      context 'when params is a JSON-string' do
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

  describe '.update_personal_info' do
    include described_class::UpdatePersonalInfo::SpecHelper

    subject(:result) { described_class.update_personal_info(id, params) }

    let(:id) { individual.id }
    let(:individual) { create(:individual) }
    let(:params_factory) { 'params/actions/individuals/update_personal_info' }
    let(:params) { create(params_factory, *traits) }
    let(:traits) { [] }

    describe 'result' do
      subject { result }

      it { is_expected.to match_json_schema(schema) }
    end

    it 'shouldn\'t update `created_at` field' do
      expect { subject }.not_to change { individual.reload.created_at }
    end

    it 'should update fields of the record' do
      subject
      individual.reload

      expect(individual.name).to be == params[:first_name]
      expect(individual.surname).to be == params[:last_name]
      expect(individual.middle_name).to be == params[:middle_name]
      expect(individual.birth_place).to be == params[:birth_place]
      expect(individual.birthday).to be == Date.parse(params[:birth_date])
      expect(individual.sex).to be == params[:sex]
      expect(individual.citizenship).to be == params[:citizenship]
    end

    it 'should create a record of identity document of the individual' do
      expect { subject }
        .to change { Cab::Models::IdentityDocument.count }
        .by(1)
    end

    context 'when file of identity document isn\'t found' do
      let(:traits) { [identity_document: doc] }
      let(:doc) { create('params/identity_document', file_id: file_id) }
      let(:file_id) { create(:uuid) }

      it 'should raise Sequel::ForeignKeyConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
      end

      it 'shouldn\'t create record of identity document of the individual' do
        expect { subject }
          .to raise_error(Sequel::ForeignKeyConstraintViolation)
          .and change { Cab::Models::IdentityDocument.count }
          .by(0)
      end
    end

    context 'when file of identity document belongs to other document' do
      let(:traits) { [identity_document: doc] }
      let(:doc) { create('params/identity_document', file_id: file_id) }
      let(:file_id) { other_document.file_id }
      let!(:other_document) { create(:identity_document) }

      it 'should raise Sequel::UniqueConstraintViolation' do
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
      end

      it 'shouldn\'t create record of identity document of the individual' do
        expect { subject }
          .to raise_error(Sequel::UniqueConstraintViolation)
          .and change { Cab::Models::IdentityDocument.count }
          .by(0)
      end
    end

    context 'when there is `id` property in params' do
      let(:params) { create(params_factory, traits) }
      let(:traits) { { id: new_id } }
      let(:new_id) { create(:uuid) }

      it 'should ignore it' do
        expect { subject }.not_to change { individual.reload.id }
      end
    end

    context 'when there is additional property in params' do
      let(:params) { { identity_document: identity_document, some: :value } }
      let(:identity_document) { create('params/identity_document') }

      it 'should ignore it' do
        expect { subject }.not_to change { individual.reload.values }
      end
    end

    context 'when params is of String type' do
      context 'when params is a JSON-string' do
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
