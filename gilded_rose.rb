class GildedRose

  MAX_QUALITY = 50
  MIN_QUALITY = 0

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def update_quality
    items.each do |item|
      adjust_quality_at_start_for(item)

      decrement_sell_in_for(item)

      adjust_quality_after_sell_in_decremented_for(item)
    end
  end

  private

  def adjust_quality_at_start_for(item)
    if item.name != Item::AGED_BRIE and item.name != Item::BACKSTAGE_PASSES
      decrement_quality_for(item)
    else
      if item.name == Item::BACKSTAGE_PASSES
        if item.sell_in >= 11
          increment_quality_for(item, 1)
        elsif item.sell_in < 11 && item.sell_in >=6
          increment_quality_for(item, 2)
        else
          increment_quality_for(item, 3)
        end
      else
        increment_quality_for(item, 1)
      end
    end
  end

  def adjust_quality_after_sell_in_decremented_for(item)
    if item.sell_in < 0
      case item.name
      when Item::AGED_BRIE
        increment_quality_for(item, 1)
      when Item::BACKSTAGE_PASSES
        decrement_quality_for(item, item.quality)
      else
        decrement_quality_for(item)
      end
    end
  end

  def decrement_sell_in_for(item, decremented_value = 1)
    decrement_attribute_for(item, :sell_in, decremented_value)
  end

  def decrement_quality_for(item, decremented_value = 1)
    decrement_attribute_for(item, :quality, decremented_value) if item.quality > MIN_QUALITY
  end

  def decrement_attribute_for(item, attribute, decremented_value)
    if item.name != Item::SULFURAS
      decremented_attribute = item.public_send(attribute) - decremented_value
      instance_variable_as_symbol = "@#{attribute}".to_sym

      item.instance_variable_set(instance_variable_as_symbol, decremented_attribute)
    end
  end

  def increment_quality_for(item, added_value)
    if item.quality < MAX_QUALITY
      new_quality = item.quality + added_value
      item.quality = new_quality <= 50 ? new_quality : 50
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert".freeze
  AGED_BRIE = "Aged Brie".freeze
  SULFURAS = "Sulfuras, Hand of Ragnaros".freeze

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
