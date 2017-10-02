require File.join(File.dirname(__FILE__), 'item')

describe Item do
  describe '#adjust_quality_at_start' do
    context 'for aged brie' do
    end

    context 'for backstage passes' do
    end

    context 'for all other items' do
      it 'decrements the quality' do
        item = Item.new(name="Elixir of the Mongoose", sell_in=1, quality=7)

        item.adjust_quality_at_start

        expect(item.quality).to eq 6
      end

      it 'does not allow the quality to be negative' do
        item = Item.new(name="Elixir of the Mongoose", sell_in=1, quality=0)

        item.adjust_quality_at_start

        expect(item.quality). to eq 0
      end
    end
  end
end
