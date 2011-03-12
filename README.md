# Description

ClosureClass is an experimental Lua object-orientation library, with the catch that it uses the [closure approach](http://lua-users.org/wiki/ObjectOrientationClosureApproach) instead of the traditional use of table indexing and such. It's based off [MiddleClass](http://github.com/kikito/middleclass) in design.

Note that performance isn't good for this library at present. When compared against MiddleClass, for creating instances of classes, it's about two times as slow, and takes more than two times as much memory. However, it does take about 4/5 the speed of MiddleClass when accessing and calling instance methods.

# Difference in Use

Take this code using MiddleClass for example:

    Foo = class('Foo')
    
    function Foo:initialize()
      self.hello = 3
      self.boo = 4
      self:initSomeMore()
    end
    
    function Foo:initSomeMore()
      -- blah!
    end
    
    function Foo:instanceFunc()
      -- blah!
    end
    
    f = Foo:new()
    f:instanceFunc()
    
    Bar = class('Bar', Foo)
    
    function Bar:initialize()
      Foo.initialize(self)
      self.bar = 5
    end
    
We can do the same thing in ClosureClass using this:

    Foo = class('Foo', function(self)
      function self.initSomeMore()
        -- blah!
      end
      
      function self.instanceFunc()
        -- blah!
      end
    
      self.hello = 3
      self.boo = 4
      self.initSomeMore()
    end)
    
    f = Foo.new()
    f.instanceFunc()
    
    Bar = class('Bar', Foo, function(self)
      -- initialization function implicitly called for now
      self.bar = 5
    end)
    
Mixins are relatively the same in ClosureClass:

    Mixin = {}
    
    function Mixin:something()
      print('blah!')
    end
    
    Foo = class('Foo').include(Mixin)
    f = Foo.new()
    f.something() -- "blah!"
    
Notice how we declare mixin functions with self as a parameter. This is because mixin functions are outside the main closure. However, ClosureClass wraps these function so that using the colon syntax of calling methods isn't needed.