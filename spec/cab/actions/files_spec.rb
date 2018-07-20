# frozen_string_literal: true

# Тестирование функций модуля `Cab::Actions::Files`

RSpec.describe Cab::Actions::Files do
  describe 'the module' do
    subject { described_class }

    it { is_expected.to respond_to(:create, :show) }
  end

  describe '.create' do
    include described_class::Create::SpecHelper

    subject(:result) { described_class.create(content) }

    let(:content) { create(:string) }
    let(:file) { Cab::Models::File[subject[:id]] }

    it 'should create file record' do
      expect { subject }.to change { Cab::Models::File.count }.by(1)
    end

    it 'should set timestamp of created record to now' do
      expect(file.created_at).to be_within(1).of(Time.now)
    end

    describe 'result' do
      subject { result }

      it { is_expected.to match_json_schema(schema) }
    end

    context 'when `content` responds to #each' do
      let(:content) { StringIO.new(str) }
      let(:str) { create(:string) }

      it 'should call #each of `content`' do
        expect(content).to receive(:each).and_call_original
        subject
      end

      it 'should use result of calling #each as the file content' do
        expect(file.content).to be == str
      end

      context 'when `content` responds to #rewind' do
        it 'should call #rewind of `content`' do
          expect(content).to receive(:rewind).and_call_original
          subject
        end
      end
    end

    context 'when `content` does not respond to #each' do
      let(:content) { create(:string) }

      it 'should use `content` as the file content' do
        expect(file.content).to be == content
      end
    end
  end

  describe '.show' do
    subject(:result) { described_class.show(params, rest) }

    let(:params) { data }
    let(:data) { { id: id } }
    let(:id) { file.id }
    let(:file) { create(:file) }
    let(:rest) { nil }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    describe 'result' do
      subject { result }

      it { is_expected.to be_a(String) }

      it 'should coincide with file content' do
        expect(subject).to be == file.content
      end
    end

    context 'when file record isn\'t found' do
      let(:id) { create(:uuid) }

      it 'should raise `Sequel::NoMatchingRow' do
        expect { subject }.to raise_error(Sequel::NoMatchingRow)
      end
    end
  end

  describe '.update' do
    subject { described_class.update(params, rest) }

    let(:params) { data }
    let(:data) { { id: id, content: content } }
    let(:content) { 'content' }
    let(:id) { file.id }
    let!(:file) { create(:file) }
    let(:rest) { nil }

    it_should_behave_like 'an action parameters receiver', wrong_structure: {}

    context 'when `content` responds to #read' do
      let(:content) { StringIO.new(str) }
      let(:str) { create(:string) }

      it 'should call #read of `content`' do
        expect(content).to receive(:read)
        subject
      end

      it 'should use result of calling #read as the file content' do
        subject
        expect(file.reload.content.to_s).to be == str
      end

      context 'when `content` responds to #rewind' do
        it 'should call #rewind of `content`' do
          expect(content).to receive(:rewind)
          subject
        end
      end
    end

    context 'when `content` does not respond to #read' do
      let(:content) { create(:string) }

      it 'should use `content` as the file content' do
        subject
        expect(file.reload.content.to_s).to be == content
      end
    end

    context 'when file record isn\'t found' do
      let(:id) { create(:uuid) }

      it 'should raise `Sequel::NoMatchingRow' do
        expect { subject }.to raise_error(Sequel::NoMatchingRow)
      end
    end
  end
end
