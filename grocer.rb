def consolidate_cart(cart)
  new_hash = {}
  new_cart = {}
  grouped = cart.group_by{ |el| el }
  grouped.each do |k,v|
    orig_hash = k
    k.each do |item, desc|
      orig_hash[item][:count] = v.length
      new_cart = new_cart.merge(orig_hash)
    end
  end
  return new_cart
end

def apply_coupons(cart, coupons)

  new_cart = {}

  temp_hash = {}

if coupons.length == 0
  return cart
end

# new CART
# Avocado's w/ Coupon => { count => 2}
#

cart.each do |citem, cdesc|
    coupons.each do |coupon_hash|
      if coupon_hash[:item] == citem
        cdesc[:count] -= coupon_hash[:num]
        coupon_name = "#{citem} W/COUPON"
          if new_cart.has_key?(coupon_name)
            new_cart[coupon_name][:count] += 1
          else
          new_cart[coupon_name] = {:price => coupon_hash[:cost], :clearance => cdesc[:clearance], :count => 1}
        end
          new_cart[citem] = {:price => cdesc[:price], :clearance => cdesc[:clearance], :count => cdesc[:count]}
        else
        new_cart[citem] = cdesc
      end
    end
  end
  return new_cart
end


def apply_clearance(cart)
    cart.each do |citem, cdesc|
        if cdesc[:clearance]
          cdesc[:price] = ((cdesc[:price]) * 0.8).round(1)
        end
      end
    return cart
  end

def checkout(cart, coupons)
  if cart.length > 0
    new_cart = consolidate_cart(cart)
    new_cart = apply_coupons(new_cart, coupons)
    new_cart = apply_clearance(new_cart)

    total_price = 0
    new_cart.each do |citem, cdesc|
       total_price += cdesc[:price] * cdesc[:count]
     end
     if total_price > 100
       total_price = (total_price * 0.9).round(1)
     end
     return total_price
  end
end
