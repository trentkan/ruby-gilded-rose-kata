require './item_wrapper'

class GildedRose

  MAX_QUALITY = 50
  MIN_QUALITY = 0

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def update_quality
    items.each do |item|
      simulate_day_for(ItemWrapper.new(item))
    end
  end

  private

  def simulate_day_for(item)
    item.adjust_quality_at_start

    item.decrement_sell_in

    item.adjust_quality_after_sell_in_day_passed
  end
end
