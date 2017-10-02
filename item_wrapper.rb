class ItemWrapper

  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert".freeze
  AGED_BRIE = "Aged Brie".freeze
  SULFURAS = "Sulfuras, Hand of Ragnaros".freeze
  DEXTERITY_VEST = "+5 Dexterity Vest".freeze
  ELIXIR = "Elixir of the Mongoose".freeze
  CONJURED = "Conjured Mana Cake".freeze

  MIN_QUALITY = 0.freeze
  MAX_QUALITY = 50.freeze

  def initialize(real_item)
    @real_item = real_item
  end

  def adjust_quality_at_start
    if real_item.name != AGED_BRIE and real_item.name != BACKSTAGE_PASSES
      decrement_quality_by(1)
    else
      if real_item.name == BACKSTAGE_PASSES
        if real_item.sell_in >= 11
          increment_quality_by(1)
        elsif real_item.sell_in < 11 && real_item.sell_in >=6
          increment_quality_by(2)
        else
          increment_quality_by(3)
        end
      else
        increment_quality_by(1)
      end
    end
  end

  def decrement_sell_in
    decrement_attribute(:sell_in, 1)
  end

  def adjust_quality_after_sell_in_day_passed
    if real_item.sell_in < 0
      case real_item.name
      when AGED_BRIE
        increment_quality_by(1)
      when BACKSTAGE_PASSES
        decrement_quality_by(real_item.quality)
      else
        decrement_quality_by(1)
      end
    end
  end

  def to_s()
    "#{real_item.name}, #{real_item.sell_in}, #{real_item.quality}"
  end

  private

  attr_accessor :real_item

  def decrement_quality_by(decremented_value)
    adjusted_decremented_value = real_item.name == CONJURED ? decremented_value * 2 : decremented_value
    decrement_attribute(:quality, adjusted_decremented_value) if real_item.quality > MIN_QUALITY
  end

  def decrement_attribute(attribute, decremented_value)
    if real_item.name != SULFURAS
      decremented_attribute = real_item.public_send(attribute) - decremented_value
      instance_variable_as_symbol = "@#{attribute}".to_sym

      real_item.instance_variable_set(instance_variable_as_symbol, decremented_attribute)
    end
  end

  def increment_quality_by(incremented_value)
    if real_item.quality < MAX_QUALITY
      new_quality = real_item.quality + incremented_value
      real_item.quality = new_quality <= 50 ? new_quality : 50
    end
  end
end
