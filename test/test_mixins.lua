require 'closureclass'

describe('Mixins', function()
  local A = class('A')
  
  local Mixin = {
    a = function(self, a) return a end,
    b = function(self, b) return b + b end
  }
  
  A.include(Mixin)
  local instance = A.new()
  
  test('Mixin should be registered in the __modules table', function()
    assert_equal(A.__modules[Mixin], Mixin)
  end)
  
  test('Mixin functionality should be included in instances', function()
    assert_not_nil(instance.a)
    assert_not_nil(instance.b)
    assert_not_error(function() instance.a(1) end)
    assert_not_error(function() instance.b(1) end)
  end)
  
  test('Mixin functions should be able to receive parameters', function()
    assert_equal(instance.a(1), 1)
    assert_equal(instance.b(1), 2)
  end)
end)