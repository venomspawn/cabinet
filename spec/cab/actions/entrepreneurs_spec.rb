# frozen_string_literal: true

# Тестирование действий над записями индивидуальных предпринимателей

RSpec.describe Cab::Actions::Entrepreneurs do
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

    subject(:result) { described_class.create(params, rest) }

    let(:rest) { nil }
    let(:params) { data }
    let(:data) { create('params/actions/entrepreneurs/create', *traits) }
    let(:traits) { %i[with_individual] }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    describe 'result' do
      subject { result }

      it { is_expected.to match_json_schema(schema) }
    end

    context 'when information about individual is provided' do
      it 'should create a record of the individual' do
        expect { subject }.to change { Cab::Models::Individual.count }.by(1)
      end

      it 'should create a record of identity document of the individual' do
        expect { subject }
          .to change { Cab::Models::IdentityDocument.count }
          .by(1)
      end

      it 'should create a record of the entrepreneur' do
        expect { subject }.to change { Cab::Models::Entrepreneur.count }.by(1)
      end

      context 'when file of agreement isn\'t found' do
        let(:traits) { [:with_individual, agreement_id: create(:uuid)] }

        it_should_behave_like 'a transactional action',
                              error: Sequel::ForeignKeyConstraintViolation,
                              shouldnt_create: %i[
                                Individual
                                IdentityDocument
                                Entrepreneur
                                VicariousAuthority
                                EntrepreneurSpokesman
                              ]
      end

      context 'when file of agreement belongs to other individual record' do
        let(:traits) { [:with_individual, agreement_id: agreement_id] }
        let(:agreement_id) { other_individual.agreement_id }
        let!(:other_individual) { create(:individual) }

        it_should_behave_like 'a transactional action',
                              error: Sequel::UniqueConstraintViolation,
                              shouldnt_create: %i[
                                Individual
                                IdentityDocument
                                Entrepreneur
                                VicariousAuthority
                                EntrepreneurSpokesman
                              ]
      end

      context 'when file of identity document isn\'t found' do
        let(:traits) { [:with_individual, identity_document: doc] }
        let(:doc) { create('params/identity_document', file_id: file_id) }
        let(:file_id) { create(:uuid) }

        it_should_behave_like 'a transactional action',
                              error: Sequel::ForeignKeyConstraintViolation,
                              shouldnt_create: %i[
                                Individual
                                IdentityDocument
                                Entrepreneur
                                VicariousAuthority
                                EntrepreneurSpokesman
                              ]
      end

      context 'when file of identity document belongs to other document' do
        let(:traits) { [:with_individual, identity_document: doc] }
        let(:doc) { create('params/identity_document', file_id: file_id) }
        let(:file_id) { other_document.file_id }
        let!(:other_document) { create(:identity_document) }

        it_should_behave_like 'a transactional action',
                              error: Sequel::UniqueConstraintViolation,
                              shouldnt_create: %i[
                                Individual
                                IdentityDocument
                                Entrepreneur
                                VicariousAuthority
                                EntrepreneurSpokesman
                              ]
      end

      context 'when there is information about spokesman' do
        let(:traits) { %i[with_individual with_spokesman] }

        it 'should create a record of vicarious authority' do
          expect { subject }
            .to change { Cab::Models::VicariousAuthority.count }
            .by(1)
        end

        it 'should create a record of link with spokesman' do
          expect { subject }
            .to change { Cab::Models::EntrepreneurSpokesman.count }
            .by(1)
        end

        context 'when the record of spokesman isn\'t found' do
          let(:traits) { [:with_individual, :with_spokesman, args] }
          let(:args) { { spokesman: spokesman } }
          let(:spokesman) { create('params/spokesman', id: create(:uuid)) }

          it_should_behave_like 'a transactional action',
                                error: Sequel::ForeignKeyConstraintViolation,
                                shouldnt_create: %i[
                                  Individual
                                  IdentityDocument
                                  Entrepreneur
                                  VicariousAuthority
                                  EntrepreneurSpokesman
                                ]
        end

        context 'when file of vicarious authority isn\'t found' do
          let(:traits) { [:with_individual, :with_spokesman, args] }
          let(:args) { { spokesman: spokesman } }
          let!(:spokesman) { create('params/spokesman', file_id: file_id) }
          let(:file_id) { create(:uuid) }

          it_should_behave_like 'a transactional action',
                                error: Sequel::ForeignKeyConstraintViolation,
                                shouldnt_create: %i[
                                  Individual
                                  IdentityDocument
                                  Entrepreneur
                                  VicariousAuthority
                                  EntrepreneurSpokesman
                                ]
        end

        context 'when file of vicarious authority belongs to other record' do
          let(:traits) { [:with_individual, :with_spokesman, args] }
          let(:args) { { spokesman: spokesman } }
          let!(:spokesman) { create('params/spokesman', file_id: file_id) }
          let(:file_id) { other_vicarious_authority.file_id }
          let(:other_vicarious_authority) { create(:vicarious_authority) }

          it_should_behave_like 'a transactional action',
                                error: Sequel::UniqueConstraintViolation,
                                shouldnt_create: %i[
                                  Individual
                                  IdentityDocument
                                  Entrepreneur
                                  VicariousAuthority
                                  EntrepreneurSpokesman
                                ]
        end
      end
    end

    context 'when information about individual id is provided' do
      let(:traits) { %i[with_individual_id] }

      it 'should create a record of the entrepreneur' do
        expect { subject }.to change { Cab::Models::Entrepreneur.count }.by(1)
      end

      context 'when the record of individual isn\'t found' do
        let(:traits) { [:with_individual_id, individual_id: create(:uuid)] }

        it_should_behave_like 'a transactional action',
                              error: Sequel::ForeignKeyConstraintViolation,
                              shouldnt_create: %i[
                                Entrepreneur
                                VicariousAuthority
                                EntrepreneurSpokesman
                              ]
      end

      context 'when there is information about spokesman' do
        let(:traits) { %i[with_individual_id with_spokesman] }

        it 'should create a record of vicarious authority' do
          expect { subject }
            .to change { Cab::Models::VicariousAuthority.count }
            .by(1)
        end

        it 'should create a record of link with spokesman' do
          expect { subject }
            .to change { Cab::Models::EntrepreneurSpokesman.count }
            .by(1)
        end

        context 'when the record of spokesman isn\'t found' do
          let(:traits) { [:with_individual_id, :with_spokesman, args] }
          let(:args) { { spokesman: spokesman } }
          let(:spokesman) { create('params/spokesman', id: create(:uuid)) }

          it_should_behave_like 'a transactional action',
                                error: Sequel::ForeignKeyConstraintViolation,
                                shouldnt_create: %i[
                                  Entrepreneur
                                  VicariousAuthority
                                  EntrepreneurSpokesman
                                ]
        end

        context 'when file of vicarious authority isn\'t found' do
          let(:traits) { [:with_individual_id, :with_spokesman, args] }
          let(:args) { { spokesman: spokesman } }
          let!(:spokesman) { create('params/spokesman', file_id: file_id) }
          let(:file_id) { create(:uuid) }

          it_should_behave_like 'a transactional action',
                                error: Sequel::ForeignKeyConstraintViolation,
                                shouldnt_create: %i[
                                  Entrepreneur
                                  VicariousAuthority
                                  EntrepreneurSpokesman
                                ]
        end

        context 'when file of vicarious authority belongs to other record' do
          let(:traits) { [:with_individual_id, :with_spokesman, args] }
          let(:args) { { spokesman: spokesman } }
          let!(:spokesman) { create('params/spokesman', file_id: file_id) }
          let(:file_id) { other_vicarious_authority.file_id }
          let(:other_vicarious_authority) { create(:vicarious_authority) }

          it_should_behave_like 'a transactional action',
                                error: Sequel::UniqueConstraintViolation,
                                shouldnt_create: %i[
                                  Entrepreneur
                                  VicariousAuthority
                                  EntrepreneurSpokesman
                                ]
        end
      end
    end
  end

  describe '.create_vicarious_authority' do
    subject(:result) { described_class.create_vicarious_authority(*args) }

    let(:args) { [params, rest] }
    let(:rest) { nil }
    let(:id) { record.id }
    let(:record) { create(:entrepreneur) }
    let(:factory) { 'params/actions/entrepreneurs/create_vicarious_authority' }
    let(:params) { data }
    let(:data) { create(factory, *traits) }
    let(:traits) { [id: id] }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    it 'should create a record of vicarious authority' do
      expect { subject }
        .to change { Cab::Models::VicariousAuthority.count }
        .by(1)
    end

    it 'should create a record of link between entrepreneur and spokesman' do
      expect { subject }
        .to change { Cab::Models::EntrepreneurSpokesman.count }
        .by(1)
    end

    context 'when the record of entrepreneur isn\'t found' do
      let(:id) { create(:uuid) }

      it_should_behave_like 'a transactional action',
                            error: Sequel::ForeignKeyConstraintViolation,
                            shouldnt_create: %i[
                              VicariousAuthority
                              EntrepreneurSpokesman
                            ]
    end

    context 'when the record of spokesman isn\'t found' do
      let(:traits) { [id: id, spokesman_id: create(:uuid)] }

      it_should_behave_like 'a transactional action',
                            error: Sequel::ForeignKeyConstraintViolation,
                            shouldnt_create: %i[
                              VicariousAuthority
                              EntrepreneurSpokesman
                            ]
    end

    context 'when file isn\'t found' do
      let(:traits) { [id: id, file_id: create(:uuid)] }

      it_should_behave_like 'a transactional action',
                            error: Sequel::ForeignKeyConstraintViolation,
                            shouldnt_create: %i[
                              VicariousAuthority
                              EntrepreneurSpokesman
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
                              EntrepreneurSpokesman
                            ]
    end
  end

  describe '.lookup' do
    include described_class::Lookup::SpecHelper

    subject(:result) { described_class.lookup(params, rest) }

    let(:rest) { nil }
    let(:data) { { first_name: create(:string) } }

    it_should_behave_like 'an action parameters receiver',
                          wrong_structure: { first_name: 1 }

    describe 'result' do
      subject { result }

      context 'when there are exact matches' do
        let(:params) { { first_name: first_name } }
        let(:first_name) { create(:string) }
        let(:limit) { described_class::Lookup::LIMIT }
        let!(:exact) { create_entrepreneurs(limit + 1, name: first_name) }
        let!(:other) { create_entrepreneurs(2) }

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
            let!(:ones) { create_entrepreneurs(limit + 1, one_traits) }
            let(:one_traits) { { name: first_name, surname: create(:string) } }
            let!(:exact) { create_entrepreneurs(limit + 1, exact_traits) }
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
        let!(:other) { create_entrepreneurs(2) }

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
            let!(:ones) { create_entrepreneurs(limit + 1, one_traits) }
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
          let!(:fuzzy) { create_entrepreneurs(limit + 1, fuzzy_traits) }
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
  end

  describe '.show' do
    include described_class::Show::SpecHelper

    subject(:result) { described_class.show(params, rest) }

    let(:rest) { nil }
    let(:data) { { id: id } }
    let(:id) { entrepreneur.id }
    let(:entrepreneur) { create(:entrepreneur) }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    describe 'result' do
      subject { result }

      let(:params) { { id: id, extended: extended } }
      let!(:identity_documents) { create_list(:identity_document, 2, traits) }
      let(:traits) { { individual_id: entrepreneur.individual_id } }

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
  end

  describe '.update' do
    subject(:result) { described_class.update(params, rest) }

    let(:rest) { nil }
    let(:id) { entrepreneur.id }
    let(:entrepreneur) { create(:entrepreneur) }
    let(:individual) { Cab::Models::Individual[entrepreneur.individual_id] }
    let(:data) { create('params/actions/entrepreneurs/update', id: id) }
    let(:params) { data }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    it 'shouldn\'t update `created_at` field' do
      expect { subject }.not_to change { entrepreneur.reload.created_at }
    end

    it 'should update fields of the record' do
      subject
      entrepreneur.reload

      expect(entrepreneur.commercial_name).to be == params[:commercial_name]
      expect(entrepreneur.ogrn).to be == params[:ogrn]

      expect(entrepreneur.actual_address.to_hash.symbolize_keys)
        .to be == params[:actual_address]

      expect(entrepreneur.bank_details.to_hash.symbolize_keys)
        .to be == params[:bank_details]
    end

    it 'should update fields of the individual record' do
      subject
      individual.reload

      expect(individual.snils).to be == params[:snils]
      expect(individual.inn).to be == params[:inn]

      expect(individual.registration_address.to_hash.symbolize_keys)
        .to be == params[:registration_address]
    end
  end

  describe '.update_personal_info' do
    include described_class::UpdatePersonalInfo::SpecHelper

    subject(:result) { described_class.update_personal_info(params, rest) }

    let(:rest) { nil }
    let(:id) { entrepreneur.id }
    let(:entrepreneur) { create(:entrepreneur) }
    let(:individual) { Cab::Models::Individual.with_pk!(individual_id) }
    let(:individual_id) { entrepreneur.individual_id }
    let(:factory) { 'params/actions/entrepreneurs/update_personal_info' }
    let(:params) { data }
    let(:data) { create(factory, *traits) }
    let(:traits) { [id: id] }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    describe 'result' do
      subject { result }

      it { is_expected.to match_json_schema(schema) }
    end

    it 'shouldn\'t update `created_at` field' do
      expect { subject }.not_to change { entrepreneur.reload.created_at }
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
      let(:traits) { [id: id, identity_document: doc] }
      let(:doc) { create('params/identity_document', file_id: file_id) }
      let(:file_id) { create(:uuid) }

      it_should_behave_like 'a transactional action',
                            error: Sequel::ForeignKeyConstraintViolation,
                            shouldnt_create: %i[IdentityDocument]
    end

    context 'when file of identity document belongs to other document' do
      let(:traits) { [id: id, identity_document: doc] }
      let(:doc) { create('params/identity_document', file_id: file_id) }
      let(:file_id) { other_document.file_id }
      let!(:other_document) { create(:identity_document) }

      it_should_behave_like 'a transactional action',
                            error: Sequel::UniqueConstraintViolation,
                            shouldnt_create: %i[IdentityDocument]
    end
  end
end
