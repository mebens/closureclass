require 'closureclass'

describe('Helper functions', function()
  local A = class('A')
  local B = class('B', A)
  local C = class('C', B)
  
  test('isClass', function()
    assert_true(isClass(A))
    assert_false(isClass({}))
    assert_false(isClass({ __closureClass = true }))
    assert_false(isClass(""))
  end)
  
  test('subclassOf', function()
    assert_true(subclassOf(Object, A))
    assert_true(subclassOf(A, B))
    assert_true(subclassOf(A, C))
    assert_false(subclassOf(C, A))
  end)
  
  test('instanceOf', function()
    local instance = A.new()
    assert_true(instanceOf(A, instance))
    assert_false(instanceOf(B, instance))
    assert_true(instanceOf(Object, instance))
  end)
  
  test('includes', function()
    local Mixin = {}
    local D = class('D').include(Mixin)
    assert_true(includes(Mixin, D))
    assert_false(includes({}, D))
  end)
end)