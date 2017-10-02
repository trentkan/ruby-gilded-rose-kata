require File.join(File.dirname(__FILE__), 'item')
require File.join(File.dirname(__FILE__), 'item_wrapper')

describe ItemWrapper do

  let(:subject) { ItemWrapper.new(item) }

  describe '#adjust_quality_at_start' do

    shared_examples 'adjusts if necessary quality at the start' do
      it 'makes the appropriate change to the quality' do
        subject.adjust_quality_at_start

        expect(item.quality).to eq expected_quality
      end
    end

    context 'for aged brie' do
      let(:original_quality) { 8 }
      let(:expected_quality) { 9 }
      let(:item) { Item.new(name=ItemWrapper::AGED_BRIE, sell_in=1, quality=original_quality) }

      it_behaves_like 'adjusts if necessary quality at the start'

      context 'with an existing quality of 50' do
        let(:original_quality) { 50 }
        let(:expected_quality) { 50 }

        it_behaves_like 'adjusts if necessary quality at the start'
      end
    end

    context 'for backstage passes' do
      let(:original_quality) { 8 }
      let(:item) { Item.new(name=ItemWrapper::BACKSTAGE_PASSES, sell_in=sell_in_days, quality=original_quality) }
      let(:sell_in_days) { 11 }

      context 'more than 10 days old' do
        let(:expected_quality) { 9 }

        it_behaves_like 'adjusts if necessary quality at the start'
      end

      context 'exactly 10 days old' do
        let(:expected_quality) { 10 }
        let(:sell_in_days) { 10 }

        it_behaves_like 'adjusts if necessary quality at the start'
      end

      context 'at least 6 days old' do
        let(:expected_quality) { 10 }
        let(:sell_in_days) { 6 }

        it_behaves_like 'adjusts if necessary quality at the start'
      end

      context 'less than 6 days old' do
        let(:expected_quality) { 11 }
        let(:sell_in_days) { 5 }

        it_behaves_like 'adjusts if necessary quality at the start'
      end

      context 'with an existing quality of 50' do
        let(:expected_quality) { 50 }
        let(:original_quality) { 50 }

        it_behaves_like 'adjusts if necessary quality at the start'
      end
    end

    context 'for conjured items' do
      let(:original_quality) { 8 }
      let(:expected_quality) { 6 }
      let(:item) { Item.new(name=ItemWrapper::CONJURED, sell_in=1, quality=original_quality) }

      it_behaves_like 'adjusts if necessary quality at the start'

      context 'with an existing quality of 0' do
        let(:original_quality) { 0 }
        let(:expected_quality) { 0 }

        it_behaves_like 'adjusts if necessary quality at the start'
      end
    end

    context 'for sulfuras' do
      let(:original_quality) { 8 }
      let(:expected_quality) { 8 }
      let(:item) { Item.new(name=ItemWrapper::SULFURAS, sell_in=1, quality=original_quality) }

      it_behaves_like 'adjusts if necessary quality at the start'
    end

    context 'for all other items' do
      let(:original_quality) { 7 }
      let(:expected_quality) { 6 }
      let(:item) { Item.new(name=[ItemWrapper::DEXTERITY_VEST, ItemWrapper::ELIXIR].sample, sell_in=1, quality=original_quality) }

      it_behaves_like 'adjusts if necessary quality at the start'

      context 'with an existing quality of 0' do
        let(:original_quality) { 0 }
        let(:expected_quality) { 0 }

        it_behaves_like 'adjusts if necessary quality at the start'
      end
    end
  end

  describe '#decrement_sell_in' do
    let(:item) { Item.new(name=item_name, sell_in=original_sell_in_days, quality=10) }

    context 'for sulfuras' do
      let(:item_name) { ItemWrapper::SULFURAS }
      let(:original_sell_in_days) { 8 }
      let(:expected_sell_in_days) { 8 }
      it 'does not decrement the sell in days' do

        subject.decrement_sell_in

        expect(item.sell_in).to eq(expected_sell_in_days)
      end
    end

    context 'for all other items' do
      let(:item_name) { [ItemWrapper::AGED_BRIE, ItemWrapper::BACKSTAGE_PASSES, ItemWrapper::DEXTERITY_VEST, ItemWrapper::ELIXIR].sample }
      let(:original_sell_in_days) { 8 }
      let(:expected_sell_in_days) { 7 }

      it 'decrements the sell in days' do
        subject.decrement_sell_in

        expect(item.sell_in).to eq(expected_sell_in_days)
      end
    end
  end

  describe '#adjust_quality_after_sell_in_day_passed' do

    shared_examples 'adjusts quality if necessary after sell in day passed' do
      it 'makes the appropriate change to the quality' do
        subject.adjust_quality_after_sell_in_day_passed

        expect(item.quality).to eq expected_quality
      end
    end

    context 'for aged brie' do
      let(:item) { Item.new(name=ItemWrapper::AGED_BRIE, sell_in=sell_in_days, quality=original_quality) }
      let(:original_quality) { 10 }
      let(:sell_in_days) { 2 }

      context 'sell in day has not passed (are not negative)' do
        let(:expected_quality) { 10 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end

      context 'sell in day has passed' do
        let(:expected_quality) { 11 }
        let(:sell_in_days) { -1 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end

      context 'with an existing quality of 50' do
        let(:original_quality) { 50 }
        let(:expected_quality) { 50 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end
    end

    context 'for backstage passes' do
      let(:item) { Item.new(name=ItemWrapper::BACKSTAGE_PASSES, sell_in=sell_in_days, quality=original_quality) }
      let(:original_quality) { 10 }
      let(:sell_in_days) { 2 }

      context 'sell in day has not passed (are not negative)' do
        let(:expected_quality) { 10 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end

      context 'sell in day has passed' do
        let(:expected_quality) { 0 }
        let(:sell_in_days) { -1 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end
    end

    context 'for conjured items' do
      let(:original_quality) { 8 }
      let(:sell_in_days) { 2 }
      let(:item) { Item.new(name=ItemWrapper::CONJURED, sell_in=sell_in_days, quality=original_quality) }

      context 'sell in day has not passed (are not negative)' do
        let(:expected_quality) { 8 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end

      context 'sell in day has passed' do
        let(:expected_quality) { 6 }
        let(:sell_in_days) { -1 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'


        context 'with an existing quality of 0' do
          let(:original_quality) { 0 }
          let(:expected_quality) { 0 }

          it_behaves_like 'adjusts quality if necessary after sell in day passed'
        end
      end

    end

    context 'for sulfuras' do
      let(:item) { Item.new(name=ItemWrapper::SULFURAS, sell_in=sell_in_days, quality=original_quality) }
      let(:original_quality) { 10 }
      let(:sell_in_days) { 2 }

      context 'sell in day has not passed (are not negative)' do
        let(:expected_quality) { 10 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end

      context 'sell in day has passed' do
        let(:expected_quality) { 10 }
        let(:sell_in_days) { -1 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end
    end

    context 'for all other items' do
      let(:item) { Item.new(name=[ItemWrapper::ELIXIR, ItemWrapper::DEXTERITY_VEST].sample, sell_in=sell_in_days, quality=original_quality) }
      let(:original_quality) { 10 }
      let(:sell_in_days) { 2 }

      context 'sell in day has not passed (are not negative)' do
        let(:expected_quality) { 10 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end

      context 'sell in day has passed' do
        let(:expected_quality) { 9 }
        let(:sell_in_days) { -1 }

        it_behaves_like 'adjusts quality if necessary after sell in day passed'
      end
    end
  end
end






















