# frozen_string_literal: true

# Тестирование действий над записями юридических лиц

RSpec.describe Cab::Actions::Organizations do
  describe 'the module' do
    subject { described_class }

    names = %i[create create_vicarious_authority lookup show update]
    it { is_expected.to respond_to(*names) }
  end

  describe '.create' do
    include described_class::Create::SpecHelper

    subject(:result) { described_class.create(params, rest) }

    let(:params) { create('params/actions/organizations/create', *traits) }
    let(:data) { create('params/actions/organizations/create') }
    let(:traits) { [] }
    let(:rest) { nil }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

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
      let(:traits) { [spokesman: spokesman] }
      let(:spokesman) { create('params/spokesman', id: create(:uuid)) }

      it_should_behave_like 'a transactional action',
                            error: Sequel::ForeignKeyConstraintViolation,
                            shouldnt_create: %i[
                              Organization
                              VicariousAuthority
                              OrganizationSpokesman
                            ]
    end

    context 'when file of vicarious authority isn\'t found' do
      let(:traits) { [spokesman: spokesman] }
      let!(:spokesman) { create('params/spokesman', file_id: file_id) }
      let(:file_id) { create(:uuid) }

      it_should_behave_like 'a transactional action',
                            error: Sequel::ForeignKeyConstraintViolation,
                            shouldnt_create: %i[
                              Organization
                              VicariousAuthority
                              OrganizationSpokesman
                            ]
    end

    context 'when file of vicarious authority belongs to other record' do
      let(:traits) { [spokesman: spokesman] }
      let!(:spokesman) { create('params/spokesman', file_id: file_id) }
      let(:file_id) { other_vicarious_authority.file_id }
      let(:other_vicarious_authority) { create(:vicarious_authority) }

      it_should_behave_like 'a transactional action',
                            error: Sequel::UniqueConstraintViolation,
                            shouldnt_create: %i[
                              Organization
                              VicariousAuthority
                              OrganizationSpokesman
                            ]
    end
  end

  describe '.create_vicarious_authority' do
    subject(:result) { described_class.create_vicarious_authority(*args) }

    let(:args) { [params, rest] }
    let(:rest) { nil }
    let(:id) { record.id }
    let(:record) { create(:organization) }
    let(:factory) { 'params/actions/organizations/create_vicarious_authority' }
    let(:params) { create(factory, *traits) }
    let(:traits) { [id: id] }
    let(:data) { create(factory, id: id) }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

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

    context 'when the record of organization isn\'t found' do
      let(:id) { create(:uuid) }

      it_should_behave_like 'a transactional action',
                            error: Sequel::ForeignKeyConstraintViolation,
                            shouldnt_create: %i[
                              VicariousAuthority
                              OrganizationSpokesman
                            ]
    end

    context 'when the record of spokesman isn\'t found' do
      let(:traits) { [id: id, spokesman_id: create(:uuid)] }

      it_should_behave_like 'a transactional action',
                            error: Sequel::ForeignKeyConstraintViolation,
                            shouldnt_create: %i[
                              VicariousAuthority
                              OrganizationSpokesman
                            ]
    end

    context 'when file isn\'t found' do
      let(:traits) { [id: id, file_id: create(:uuid)] }

      it_should_behave_like 'a transactional action',
                            error: Sequel::ForeignKeyConstraintViolation,
                            shouldnt_create: %i[
                              VicariousAuthority
                              OrganizationSpokesman
                            ]
    end

    context 'when file belongs to other vicarious authority' do
      let(:traits) { [id: id, file_id: file_id] }
      let(:file_id) { other_vicarious_authority.file_id }
      let!(:other_vicarious_authority) { create(:vicarious_authority) }

      it_should_behave_like 'a transactional action',
                            error: Sequel::UniqueConstraintViolation,
                            shouldnt_create: %i[
                              VicariousAuthority
                              OrganizationSpokesman
                            ]
    end
  end

  describe '.lookup' do
    include described_class::Lookup::SpecHelper

    subject(:result) { described_class.lookup(params, rest) }

    let(:rest) { nil }
    let(:data) { { full_name: create(:string) } }

    it_should_behave_like 'an action parameters receiver',
                          wrong_structure: { full_name: 1 }

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
          let(:fuzzy_traits) { { full_name: fuzzy_full_name } }
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
  end

  describe '.show' do
    include described_class::Show::SpecHelper

    subject(:result) { described_class.show(params, rest) }

    let(:rest) { nil }
    let(:data) { { id: id } }
    let(:id) { organization.id }
    let(:organization) { create(:organization) }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    describe 'result' do
      subject { result }

      let(:params) { data }

      it { is_expected.to match_json_schema(schema) }
    end
  end

  describe '.update' do
    subject(:result) { described_class.update(params, rest) }

    let(:rest) { nil }
    let(:id) { organization.id }
    let(:organization) { create(:organization) }
    let(:params) { data }
    let(:data) { create('params/actions/organizations/update', id: id) }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

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
  end
end
