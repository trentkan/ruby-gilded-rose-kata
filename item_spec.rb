require File.join(File.dirname(__FILE__), 'item')

describe Item do
  describe '#adjust_quality_at_start' do

    shared_examples 'the items quality adjustment behavior' do
      it 'makes the appropriate change to the quality' do
        item.adjust_quality_at_start

        expect(item.quality).to eq expected_quality
      end
    end

    context 'for aged brie' do
      let(:original_quality) { 8 }
      let(:expected_quality) { 9 }
      let(:item) { Item.new(name=Item::AGED_BRIE, sell_in=1, quality=original_quality) }

      it_behaves_like 'the items quality adjustment behavior'

      context 'with an existing quality of 50' do
        let(:original_quality) { 50 }
        let(:expected_quality) { 50 }

        it_behaves_like 'the items quality adjustment behavior'
      end
    end

    context 'for backstage passes' do
      let(:original_quality) { 8 }
      let(:item) { Item.new(name=Item::BACKSTAGE_PASSES, sell_in=sell_in_days, quality=original_quality) }
      let(:sell_in_days) { 11 }

      context 'more than 10 days old' do
        let(:expected_quality) { 9 }

        it_behaves_like 'the items quality adjustment behavior'
      end

      context 'exactly 10 days old' do
        let(:expected_quality) { 10 }
        let(:sell_in_days) { 10 }

        it_behaves_like 'the items quality adjustment behavior'
      end

      context 'at least 6 days old' do
        let(:expected_quality) { 10 }
        let(:sell_in_days) { 6 }

        it_behaves_like 'the items quality adjustment behavior'
      end

      context 'less than 6 days old' do
        let(:expected_quality) { 11 }
        let(:sell_in_days) { 5 }

        it_behaves_like 'the items quality adjustment behavior'
      end

      context 'with an existing quality of 50' do
        let(:expected_quality) { 50 }
        let(:original_quality) { 50 }

        it_behaves_like 'the items quality adjustment behavior'
      end

    end

    context 'for sulfuras' do
      let(:original_quality) { 8 }
      let(:expected_quality) { 8 }
      let(:item) { Item.new(name=Item::SULFURAS, sell_in=1, quality=original_quality) }

      it_behaves_like 'the items quality adjustment behavior'
    end

    context 'for all other items' do
      let(:original_quality) { 7 }
      let(:expected_quality) { 6 }
      let(:item) { Item.new(name="Elixir of the Mongoose", sell_in=1, quality=original_quality) }

      it_behaves_like 'the items quality adjustment behavior'

      context 'with an existing quality of 0' do
        let(:original_quality) { 0 }
        let(:expected_quality) { 0 }

        it_behaves_like 'the items quality adjustment behavior'
      end
    end
  end
end
