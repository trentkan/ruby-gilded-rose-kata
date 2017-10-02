class GildedRose

  MAX_QUALITY = 50
  MIN_QUALITY = 0

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def update_quality
    items.each do |item|
      item.adjust_quality_at_start

      decrement_sell_in_for(item)

      adjust_quality_after_sell_in_decremented_for(item)
    end
  end

  private



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

  MIN_QUALITY = 0.freeze
  MAX_QUALITY = 50.freeze

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def adjust_quality_at_start_for(item)
    puts "name: #{name}, sell_in: #{sell_in}, quality: #{quality}"
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

  def adjust_quality_at_start
    if name != AGED_BRIE and name != BACKSTAGE_PASSES
      decrement_quality_by(1)
    else
      if name == BACKSTAGE_PASSES
        if sell_in >= 11
          increment_quality_by(1)
        elsif sell_in < 11 && sell_in >=6
          increment_quality_by(2)
        else
          increment_quality_by(3)
        end
      else
        increment_quality_by(1)
      end
    end
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end

  private

  def decrement_quality_by(decremented_value)
    decrement_attribute(:quality, decremented_value) if quality > MIN_QUALITY
  end

  def decrement_attribute(attribute, decremented_value)
    if name != SULFURAS
      decremented_attribute = public_send(attribute) - decremented_value
      instance_variable_as_symbol = "@#{attribute}".to_sym

      instance_variable_set(instance_variable_as_symbol, decremented_attribute)
    end
  end

  def increment_quality_by(incremented_value)
    if quality < MAX_QUALITY
      new_quality = quality + incremented_value
      self.quality = new_quality <= 50 ? new_quality : 50
    end
  end
end
