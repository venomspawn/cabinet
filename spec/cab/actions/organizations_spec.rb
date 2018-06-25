# frozen_string_literal: true

# Тестирование действий над записями юридических лиц

RSpec.describe Cab::Actions::Organizations do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:create, :lookup, :show, :update) }
  end

  describe '.create' do
    include described_class::Create::SpecHelper

    subject(:result) { described_class.create(params) }

    let(:params) { create('params/actions/organizations/create') }

    describe 'result' do
      subject { result }

      it { is_expected.to match_json_schema(schema) }
    end

    it 'should create a record of the organization' do
      expect { subject }.to change { Cab::Models::Organization.count }.by(1)
    end

    it 'should create a record of vicarious authority' do
      expect { subject }
        .to change { Cab::Models::VicariousAuthority.count }
        .by(1)
    end

    it 'should create a record of link between organization and spokesman' do
      expect { subject }
        .to change { Cab::Models::OrganizationSpokesman.count }
        .by(1)
    end

    context 'when the record of spokesman isn\'t found' do
      let(:params) { create('params/actions/organizations/create', traits) }
      let(:traits) { { spokesman: spokesman } }
      let(:spokesman) { create('params/spokesman', id: create(:uuid)) }

      it 'should raise Sequel::NoMatchingRow' do
        expect { subject }.to raise_error(Sequel::NoMatchingRow)
      end

      it 'shouldn\'t create records' do
        expect { subject }
          .to raise_error(Sequel::NoMatchingRow)
          .and change { Cab::Models::Organization.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::NoMatchingRow)
          .and change { Cab::Models::VicariousAuthority.count }
          .by(0)
        expect { subject }
          .to raise_error(Sequel::NoMatchingRow)
          .and change { Cab::Models::OrganizationSpokesman.count }
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
        let(:params) { { full_name: full_name } }
        let(:full_name) { create(:string) }
        let(:lim) { described_class::Lookup::LIMIT }
        let!(:exact) { create_list(:organization, lim, full_name: full_name) }
        let!(:other) { create_list(:organization, 2) }

        it { is_expected.to match_json_schema(schema) }

        it 'should have the matched info in `exact` property' do
          expect(ids(subject[:exact]) - exact.map(&:id)).to be_empty
        end

        it 'shouldn\'t have more elements in the property than limited' do
          expect(result[:exact].size).to be <= lim
        end

        it 'should have `fuzzy` property empty' do
          expect(result[:fuzzy]).to be_empty
        end

        context 'when `inn` param is blank' do
          it 'should have `without_inn` property empty' do
            expect(result[:without_inn]).to be_empty
          end
        end

        context 'when `inn` param isn\'t blank' do
          let(:params) { { full_name: full_name, inn: inn } }
          let(:inn) { create(:string, length: 10) }

          context 'when there are exact matches excluding inn' do
            let!(:ones) { create_list(:organization, lim + 1, one_traits) }
            let(:one_traits) { { full_name: full_name, inn: one_inn } }
            let(:one_inn) { create(:string, length: 10) }
            let!(:exact) { create_list(:organization, lim + 1, exact_traits) }
            let(:exact_traits) { { full_name: full_name, inn: inn } }

            it 'should have the matched info in `without_last_info`' do
              expect(ids(subject[:without_inn]) - ones.map(&:id))
                .to be_empty
            end

            it 'shouldn\'t have more elements in the property than limited' do
              expect(result[:without_inn].size).to be <= lim
            end
          end
        end
      end

      context 'when there aren\'t exact matches' do
        let(:params) { { full_name: full_name } }
        let(:full_name) { create(:string) }
        let(:lim) { described_class::Lookup::LIMIT }
        let!(:other) { create_list(:organization, 2) }

        it { is_expected.to match_json_schema(schema) }

        it 'should have `exact` property empty' do
          expect(result[:exact]).to be_empty
        end

        context 'when `inn` param is blank' do
          it 'should have `without_inn` property empty' do
            expect(result[:without_inn]).to be_empty
          end
        end

        context 'when `inn` param isn\'t blank' do
          let(:params) { { full_name: full_name, inn: inn } }
          let(:inn) { create(:string, length: 10) }

          context 'when there are exact matches excluding inn' do
            let!(:ones) { create_list(:organization, lim + 1, one_traits) }
            let(:one_traits) { { full_name: full_name, inn: one_inn } }
            let(:one_inn) { create(:string, length: 10) }

            it 'should have the matched info in `without_last_info`' do
              expect(ids(subject[:without_inn]) - ones.map(&:id))
                .to be_empty
            end

            it 'shouldn\'t have more elements in the property than limited' do
              expect(result[:without_inn].size).to be <= lim
            end
          end
        end

        context 'when there are fuzzy matches' do
          let!(:fuzzy) { create_list(:organization, lim + 1, fuzzy_traits) }
          let(:fuzzy_traits){ { full_name: fuzzy_full_name } }
          let(:fuzzy_full_name) { "#{full_name}f" }

          it 'should have the matched info in `fuzzy`' do
            expect(ids(subject[:fuzzy]) - fuzzy.map(&:id)).to be_empty
          end

          it 'shouldn\'t have more elements in the property than limited' do
            expect(result[:fuzzy].size).to be <= lim
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

      let(:params) { { id: id } }
      let(:id) { organization.id }
      let(:organization) { create(:organization) }

      it { is_expected.to match_json_schema(schema) }
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

    let(:id) { organization.id }
    let(:organization) { create(:organization) }
    let(:params) { create('params/actions/organizations/update') }

    describe 'result' do
      subject { result }

      it { is_expected.to match_json_schema(schema) }
    end

    it 'shouldn\'t update `created_at` field' do
      expect { subject }.not_to change { organization.reload.created_at }
    end

    it 'should update fields of the record' do
      subject
      organization.reload

      expect(organization.full_name).to be == params[:full_name]
      expect(organization.short_name).to be == params[:sokr_name]
      expect(organization.chief_name).to be == params[:chief_name]
      expect(organization.chief_surname).to be == params[:chief_surname]

      expect(organization.chief_middle_name)
        .to be == params[:chief_middle_name]

      expect(organization.registration_date)
        .to be == Date.parse(params[:registration_date])

      expect(organization.inn).to be == params[:inn]
      expect(organization.kpp).to be == params[:kpp]
      expect(organization.ogrn).to be == params[:ogrn]

      expect(organization.legal_address.to_hash.symbolize_keys)
        .to be == params[:legal_address]

      expect(organization.actual_address.to_hash.symbolize_keys)
        .to be == params[:actual_address]

      expect(organization.bank_details.to_hash.symbolize_keys)
        .to be == params[:bank_details]
    end

    context 'when there is `id` property in params' do
      let(:params) { create('params/actions/organizations/update', traits) }
      let(:traits) { { id: new_id } }
      let(:new_id) { create(:uuid) }

      it 'should ignore it' do
        expect { subject }.not_to change { organization.reload.id }
      end
    end

    context 'when there is additional property in params' do
      let(:params) { { additional: :property } }

      it 'should ignore it' do
        expect { subject }.not_to change { organization.reload.values }
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
