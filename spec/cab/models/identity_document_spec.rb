# frozen_string_literal: true

# Тестирование модели записи документа, удостоверяющего личность

RSpec.describe Cab::Models::IdentityDocument do
  describe 'the model' do
    subject { described_class }

    it { is_expected.to respond_to(:create, :new) }
  end

  describe '.new' do
    subject(:result) { described_class.new(params) }

    describe 'result' do
      subject { result }

      let(:params) { attributes_for(:identity_document).except(:id) }

      it { is_expected.to be_an_instance_of(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:identity_document) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end
  end

  describe '.create' do
    subject(:result) { described_class.create(params) }

    describe 'result' do
      before { described_class.unrestrict_primary_key }

      after { described_class.restrict_primary_key }

      subject { result }

      let(:params) { attributes_for(:identity_document) }

      it { is_expected.to be_a(described_class) }
    end

    context 'when `params` contains `id` attribute' do
      let(:params) { attributes_for(:identity_document) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when `params` doesn\'t contain `id` attribute' do
      let(:params) { attributes_for(:identity_document).except(:id) }

      it 'should raise Sequel::NotNullConstraintViolation' do
        expect { subject }.to raise_error(Sequel::NotNullConstraintViolation)
      end
    end

    context 'when primary key is unrestricted' do
      before { described_class.unrestrict_primary_key }

      after { described_class.restrict_primary_key }

      context 'when value of `id` property is nil' do
        let(:params) { attributes_for(:identity_document, id: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `id` property is of String' do
        context 'when the value is not of UUID format' do
          let(:params) { attributes_for(:identity_document, id: value) }
          let(:value) { 'not of UUID format' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when value of `type` property is nil' do
        let(:params) { attributes_for(:identity_document, type: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `type` property is of String' do
        context "when the value isn\'t in #{described_class::TYPES}" do
          let(:params) { attributes_for(:identity_document, type: value) }
          let(:value) { "isn't in #{described_class::TYPES}" }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when value of `series` property is nil' do
        let(:params) { attributes_for(:identity_document, series: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `issued_by` property is nil' do
        let(:params) { attributes_for(:identity_document, issued_by: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `issue_date` property is nil' do
        let(:params) { attributes_for(:identity_document, issue_date: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `issue_date` property is of String' do
        context 'when the value is not a date\'s representation' do
          let(:params) { attributes_for(:identity_document, issue_date: value) }
          let(:value) { 'not a date\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when value of `expiration_end` property is of String' do
        context 'when the value is not a date\'s representation' do
          let(:params) { attributes_for(:identity_document, traits) }
          let(:traits) { { expiration_end: value } }
          let(:value) { 'not a date\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when value of `created_at` property is nil' do
        let(:params) { attributes_for(:identity_document, created_at: value) }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `created_at` property is of String' do
        context 'when the value is not a time\'s representation' do
          let(:params) { attributes_for(:identity_document, traits) }
          let(:traits) { { created_at: value } }
          let(:value) { 'not a time\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when value of `individual_id` property is nil' do
        let(:params) { attributes_for(:identity_document, traits) }
        let(:traits) { { individual_id: value } }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `individual_id` is not a primary key' do
        let(:params) { attributes_for(:identity_document, traits) }
        let(:traits) { { individual_id: value } }
        let(:value) { create(:uuid) }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end
      end

      context 'when value of `file_id` property is nil' do
        let(:params) { attributes_for(:identity_document, traits) }
        let(:traits) { { file_id: value } }
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end

      context 'when value of `file_id` is not a primary key' do
        let(:params) { attributes_for(:identity_document, traits) }
        let(:traits) { { file_id: value } }
        let(:value) { create(:uuid) }

        it 'should raise Sequel::ForeignKeyConstraintViolation' do
          expect { subject }
            .to raise_error(Sequel::ForeignKeyConstraintViolation)
        end
      end
    end
  end

  describe 'an instance' do
    subject { create(:identity_document) }

    methods = %i[
      id
      type
      number
      series
      issued_by
      issue_date
      expiration_end
      division_code
      created_at
      individual_id
      file_id
      update
    ]

    it { is_expected.to respond_to(*methods) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
      it { is_expected.to match_uuid_format }
    end
  end

  describe '#type' do
    subject(:result) { instance.type }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      described_class::TYPES.each do |type|
        context "when `type` field is `#{type}`" do
          let(:instance) { create(:identity_document, type: type.to_s) }

          it { is_expected.to be == type.to_s }
        end
      end
    end
  end

  describe '#number' do
    subject(:result) { instance.number }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      context 'when `number` field is NULL' do
        let(:instance) { create(:identity_document, number: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `number` field isn\'t NULL' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#series' do
    subject(:result) { instance.series }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#issued_by' do
    subject(:result) { instance.issued_by }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
    end
  end

  describe '#issue_date' do
    subject(:result) { instance.issue_date }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Date) }
    end
  end

  describe '#expiration_end' do
    subject(:result) { instance.expiration_end }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      context 'when `expiration_end` field is NULL' do
        let(:instance) { create(:identity_document, expiration_end: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `expiration_end` field isn\'t NULL' do
        it { is_expected.to be_a(Date) }
      end
    end
  end

  describe '#division_code' do
    subject(:result) { instance.division_code }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      context 'when `division_code` field is NULL' do
        let(:instance) { create(:identity_document, division_code: nil) }

        it { is_expected.to be_nil }
      end

      context 'when `division_code` field isn\'t NULL' do
        it { is_expected.to be_a(String) }
      end
    end
  end

  describe '#created_at' do
    subject(:result) { instance.created_at }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(Time) }
    end
  end

  describe '#individual_id' do
    subject(:result) { instance.individual_id }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
      it { is_expected.to match_uuid_format }

      let(:individual) { Cab::Models::Individual.where(id: subject).first }

      it 'should be a primary key in the tables of individuals' do
        expect(individual).not_to be_nil
      end
    end
  end

  describe '#file_id' do
    subject(:result) { instance.file_id }

    let(:instance) { create(:identity_document) }

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }
      it { is_expected.to match_uuid_format }

      let(:file) { Cab::Models::File.where(id: subject).first }

      it 'should be a primary key in the tables of files' do
        expect(file).not_to be_nil
      end
    end
  end

  describe '#update' do
    subject { instance.update(params) }

    let(:instance) { create(:identity_document) }

    context 'when `id` property is present in parameters' do
      let(:params) { { id: value } }
      let(:value) { create(:uuid) }

      it 'should raise Sequel::MassAssignmentRestriction' do
        expect { subject }.to raise_error(Sequel::MassAssignmentRestriction)
      end
    end

    context 'when `type` property is present in parameters' do
      let(:params) { { type: value } }

      described_class::TYPES.each do |type|
        context "when the value is `#{type}`" do
          before { subject }

          let(:value) { type.to_s }

          it 'should set `type` attribute to the value' do
            expect(instance.type).to be == value
          end
        end
      end

      context "when the value isn\'t in #{described_class::TYPES}" do
        let(:value) { "isn't in #{described_class::TYPES}" }

        it 'should raise Sequel::DatabaseError' do
          expect { subject }.to raise_error(Sequel::DatabaseError)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `number` property is present in parameters' do
      let(:params) { { number: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `number` attribute of the instance to the value' do
          expect { subject }.to change { instance.number }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `number` attribute of the instance to nil' do
          expect { subject }.to change { instance.number }.to(nil)
        end
      end
    end

    context 'when `series` property is present in parameters' do
      let(:params) { { series: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `series` attribute of the instance to the value' do
          expect { subject }.to change { instance.series }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `issued_by` property is present in parameters' do
      let(:params) { { issued_by: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `issued_by` attribute of the instance to the value' do
          expect { subject }.to change { instance.issued_by }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `issue_date` property is present in parameters' do
      let(:params) { { issue_date: value } }

      context 'when the value is of String' do
        context 'when the value is a date\'s representation' do
          let(:value) { date.to_s }
          let(:date) { create(:date) }

          it 'should set `issue_date` attribute to the date' do
            expect { subject }.to change { instance.issue_date }.to(date)
          end
        end

        context 'when the value is not a date\'s representation' do
          let(:value) { 'not a date\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when the value is of Date' do
        let(:value) { create(:date) }

        it 'should set `issue_date` attribute to the value' do
          expect { subject }.to change { instance.issue_date }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `expiration_end` property is present in parameters' do
      let(:params) { { expiration_end: value } }

      context 'when the value is of String' do
        context 'when the value is a date\'s representation' do
          let(:value) { date.to_s }
          let(:date) { create(:date) }

          it 'should set `expiration_end` attribute to the date' do
            expect { subject }.to change { instance.expiration_end }.to(date)
          end
        end

        context 'when the value is not a date\'s representation' do
          let(:value) { 'not a date\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when the value is of Date' do
        let(:value) { create(:date) }

        it 'should set `expiration_end` attribute to the value' do
          expect { subject }.to change { instance.expiration_end }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `expiration_end` attribute of the instance to nil' do
          expect { subject }.to change { instance.expiration_end }.to(nil)
        end
      end
    end

    context 'when `division_code` property is present in parameters' do
      let(:params) { { division_code: value } }

      context 'when the value is of String' do
        let(:value) { create(:string) }

        it 'should set `division_code` attribute to the value' do
          expect { subject }.to change { instance.division_code }.to(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should set `division_code` attribute of the instance to nil' do
          expect { subject }.to change { instance.division_code }.to(nil)
        end
      end
    end

    context 'when `created_at` property is present in parameters' do
      let(:params) { { created_at: value } }

      context 'when the value is of String' do
        context 'when the value is a time\'s representation' do
          before { subject }

          let(:value) { created_at.to_s }
          let(:created_at) { Time.now - 1 }

          it 'should set `created_at` attribute to the date' do
            expect(instance.created_at).to be_within(1).of(created_at)
          end
        end

        context 'when the value is not a time\'s representation' do
          let(:value) { 'not a time\'s representation' }

          it 'should raise Sequel::InvalidValue' do
            expect { subject }.to raise_error(Sequel::InvalidValue)
          end
        end
      end

      context 'when the value is of Time' do
        before { subject }

        let(:value) { Time.now - 1 }

        it 'should set `created_at` attribute to the value' do
          expect(instance.created_at).to be_within(1).of(value)
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `individual_id` property is present in parameters' do
      let(:params) { { individual_id: value } }

      context 'when the value is of String' do
        context 'when the value is an UUID' do
          context 'when the value is not a primary key in individuals table' do
            let(:value) { create(:uuid) }

            it 'should raise Sequel::ForeignKeyConstraintViolation' do
              expect { subject }
                .to raise_error(Sequel::ForeignKeyConstraintViolation)
            end
          end

          context 'when the value is a primary key in individuals table' do
            let(:value) { create(:individual).id }

            it 'should set `individual_id` attribute to the value' do
              expect { subject }.to change { instance.individual_id }.to(value)
            end
          end
        end

        context 'when the value isn\'t an UUID' do
          let(:value) { 'isn\'t an UUID' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end

    context 'when `file_id` property is present in parameters' do
      let(:params) { { file_id: value } }

      context 'when the value is of String' do
        context 'when the value is an UUID' do
          context 'when the value is not a primary key in files table' do
            let(:value) { create(:uuid) }

            it 'should raise Sequel::ForeignKeyConstraintViolation' do
              expect { subject }
                .to raise_error(Sequel::ForeignKeyConstraintViolation)
            end
          end

          context 'when the value is a primary key in files table' do
            let(:value) { create(:file).id }

            it 'should set `file_id` attribute to the value' do
              expect { subject }.to change { instance.file_id }.to(value)
            end
          end
        end

        context 'when the value isn\'t an UUID' do
          let(:value) { 'isn\'t an UUID' }

          it 'should raise Sequel::DatabaseError' do
            expect { subject }.to raise_error(Sequel::DatabaseError)
          end
        end
      end

      context 'when the value is nil' do
        let(:value) { nil }

        it 'should raise Sequel::InvalidValue' do
          expect { subject }.to raise_error(Sequel::InvalidValue)
        end
      end
    end
  end
end
