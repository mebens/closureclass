require 'closureclass'

describe('Classes', function()
  local function initFunc(self, param1)
    self.pi = 3.1415926536

    function self.add(a, b)
      return a + b
    end
    
    function self.getParam()
      return param1
    end
  end
  
  describe('When creating an implicit child of Object', function()
    local A = class('A', initFunc)
    
    test('Should have its name set up correctly', function()
      assert_equal(A.name, 'A')
    end)
    
    test('Should be a subclass of Object', function()
      assert_equal(A.superclass, Object)
    end)
    
    test('Should have an empty subclasses table', function()
      assert_not_nil(A.subclasses)
      assert_empty(A.subclasses)
    end)
    
    test('Should have a __modules table', function()
      assert_not_nil(A.__modules)
    end)
    
    test('Should have a correctly set init function', function()
      assert_not_nil(A.init)
      assert_equal(initFunc, A.init)
    end)
    
    test('Should be registed as a subclass of Object', function()
      assert_equal(Object.subclasses[A.name], A)
    end)
  end) -- When creating an implicit child of Object
  
  describe("When creating a subclass", function()
    local B = class('B', initFunc)
    
    function B.add(a, b)
      return a + b
    end
    
    local C = class('C', B)
    
    describe('Superclass', function()
      test('Should have a single subclass reference for the class that subclassed it', function()
        assert_equal(B.subclasses[C.name], C)
      end)
    end)
    
    describe('Subclass', function()
      test('Should have its name set up correctly', function()
        assert_equal(C.name, 'C')
      end)

      test('Should have its superclass attribute properly set', function()
        assert_equal(C.superclass, B)
      end)

      test('Should have an empty subclasses table', function()
        assert_not_nil(C.subclasses)
        assert_empty(C.subclasses)
      end)

      test('Should have a __modules table', function()
        assert_not_nil(C.__modules)
      end)
      
      test('Should inherit instance functionality from superclass', function()
        local instance = C.new()
        assert_not_nil(instance.add)
        assert_not_error(function() instance.add(1, 1) end)
      end)
      
      test('Should inherit class functionality from superclass', function()
        assert_not_nil(C.add)
        assert_not_error(function() C.add(1, 1) end)
      end)
    end)
  end) -- When creating a subclass
  
  describe('When creating an instance', function()
    local D = class('D', initFunc)
    local instance = D.new(3)
    
    test('Should have a reference to its class', function()
      assert_equal(instance.class, D)
    end)
    
    test('Should be able to call instance functions', function()
      assert_not_nil(instance.add)
      assert_not_error(function() instance.add(1, 1) end)
    end)
    
    test('Init function should be able to take parameters', function()
      assert_equal(instance.getParam(), 3)
    end)
  end) -- When creating an instance
end)