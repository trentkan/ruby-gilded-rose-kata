class GildedRose

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def update_quality
    items.each do |item|
      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.quality > 0
          decrement_attribute_for(item, :quality)
        end
      else
        if item.quality < 50
          increment_quality_for(item, 1)
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                increment_quality_for(item, 1)
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                increment_quality_for(item, 1)
              end
            end
          end
        end
      end

      decrement_attribute_for(item, :sell_in)

      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            increment_quality_for(item, 1)
          end
        end
      end
    end
  end

  private

  def decrement_attribute_for(item, attribute)
    if item.name != "Sulfuras, Hand of Ragnaros"
      decremented_attribute = item.public_send(attribute) - 1
      instance_variable_as_symbol = "@#{attribute}".to_sym

      item.instance_variable_set(instance_variable_as_symbol, decremented_attribute)
    end
  end

  def increment_quality_for(item, added_value)
    item.quality = item.quality + added_value
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
