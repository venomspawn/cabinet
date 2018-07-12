# frozen_string_literal: true

# Тестирование модели записи связи между записями индивидуального
# предпринимателя и его представителя

RSpec.describe Cab::Models::EntrepreneurSpokesman do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create, :new) }
  end

  describe '.new' do
    subject { described_class.new(params) }

    let(:params) { attributes_for(:entrepreneur) }

    it 'should raise Sequel::MassAssignmentRestriction' do
      expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
    end
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    let(:params) { attributes_for(:entrepreneur_spokesman) }

    it 'should raise Sequel::MassAssignmentRestriction' do
      expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
    end

    context 'when primary key is unrestricted' do
      before { described_class.unrestrict_primary_key }

      after { described_class.restrict_primary_key }

      describe 'result' do
        subject { result }

        let(:params) { attributes_for(:entrepreneur_spokesman) }

        it { is_expected.to be_a(described_class) }
      end

      context 'when primary key repeats' do
        let(:other_one) { create(:entrepreneur_spokesman) }
        let(:params) { other_one.values }

        it 'should raise Sequel::UniqueConstraintViolation' do
          expect { subject }.to raise_error(Sequel::UniqueConstraintViolation)
        end
      end

      context 'when value of `created_at` property is nil' do
        let(:params) { attributes_for(:entrepreneur_spokesman, traits) }
        let(:traits) { { created_at: nil } }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `created_at` property is of String' do
        context 'when the value is not a time\'s representation' do
          let(:params) { attributes_for(:entrepreneur_spokesman, traits) }
          let(:traits) { { created_at: value } }
          let(:value) { 'not a time\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when value of `spokesman_id` property is nil' do
        let(:params) { attributes_for(:entrepreneur_spokesman, traits) }
        let(:traits) { { spokesman_id: value } }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `spokesman_id` is not a primary key' do
        let(:params) { attributes_for(:entrepreneur_spokesman, traits) }
        let(:traits) { { spokesman_id: value } }
        let(:value) { create(:uuid) }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end
      end

      context 'when value of `entrepreneur_id` property is nil' do
        let(:params) { attributes_for(:entrepreneur_spokesman, traits) }
        let(:traits) { { entrepreneur_id: value } }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `entrepreneur_id` is not a primary key' do
        let(:params) { attributes_for(:entrepreneur_spokesman, traits) }
        let(:traits) { { entrepreneur_id: value } }
        let(:value) { create(:uuid) }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end
      end

      context 'when value of `vicarious_authority_id` property is nil' do
        let(:params) { attributes_for(:entrepreneur_spokesman, traits) }
        let(:traits) { { vicarious_authority_id: value } }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `vicarious_authority_id` is not a primary key' do
        let(:params) { attributes_for(:entrepreneur_spokesman, traits) }
        let(:traits) { { vicarious_authority_id: value } }
        let(:value) { create(:uuid) }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end
      end
    end
  end

  describe 'an instance' do
    subject { create(:entrepreneur_spokesman) }

    methods = %i[
      created_at
      spokesman_id
      entrepreneur_id
      vicarious_authority_id
      destroy
      update
    ]

    it { is_expected.to respond_to(*methods) }
  end

  describe '#created_at' do
    subject(:result) { instance.created_at }

    let(:instance) { create(:entrepreneur_spokesman) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Time) }
    end
  end

  describe '#spokesman_id' do
    subject(:result) { instance.spokesman_id }

    let(:instance) { create(:entrepreneur_spokesman) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should be an UUID' do
        hex = '[0-9a-fA-F]'
        expect(subject)
          .to match(/^#{hex}{8}-#{hex}{4}-#{hex}{4}-#{hex}{4}-#{hex}{12}$/)
      end

      let(:individual) { Cab::Models::Individual.where(id: subject).first }

      it 'should be a primary key in the tables of individuals' do
        expect(individual).not_to be_nil
      end
    end
  end

  describe '#entrepreneur_id' do
    subject(:result) { instance.entrepreneur_id }

    let(:instance) { create(:entrepreneur_spokesman) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should be an UUID' do
        hex = '[0-9a-fA-F]'
        expect(subject)
          .to match(/^#{hex}{8}-#{hex}{4}-#{hex}{4}-#{hex}{4}-#{hex}{12}$/)
      end

      let(:entrepreneur) { Cab::Models::Entrepreneur.where(id: subject).first }

      it 'should be a primary key in the tables of entrepreneurs' do
        expect(entrepreneur).not_to be_nil
      end
    end
  end

  describe '#vicarious_authority_id' do
    subject(:result) { instance.vicarious_authority_id }

    let(:instance) { create(:entrepreneur_spokesman) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should be an UUID' do
        hex = '[0-9a-fA-F]'
        expect(subject)
          .to match(/^#{hex}{8}-#{hex}{4}-#{hex}{4}-#{hex}{4}-#{hex}{12}$/)
      end

      let(:model) { Cab::Models::VicariousAuthority }
      let(:vicarious_authority) { model.where(id: subject).first }

      it 'should be a primary key in the tables of vicarious authorities' do
        expect(vicarious_authority).not_to be_nil
      end
    end
  end

  describe '#destroy' do
    subject { instance.destroy }

    let(:instance) { create(:entrepreneur_spokesman) }
    let(:pkey) { instance.pk }
    let(:model) { Cab::Models::EntrepreneurSpokesman }

    it 'should delete the record' do
      expect { subject }.to change { model.with_pk(pkey) }.to(nil)
    end
  end

  describe '#update' do
    subject { instance.update(params) }

    let(:instance) { create(:entrepreneur_spokesman) }
    let(:params) { attributes_for(:entrepreneur_spokesman) }

    it 'should raise Sequel::MassAssignmentRestriction' do
      expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
    end
  end
end
