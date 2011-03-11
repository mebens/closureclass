-- info
local _classes = {}

-- Object
Object = {
  subclasses = {},
  name = 'Object',
  __modules = {},
  __closureClass = true,
  __tostring = function() return 'class Object' end,
  __call = function(_, ...) return Object.new(...) end
}

_classes.Object = Object

function Object._new(cls, ...)
  local self
  
  if cls.superclass then
    -- Object subclass - base this class off an instance of the super class
    self = cls.superclass.new()
    self.class = cls
  else
    -- Object itself - create a new class
    self = { class = cls }
  end
  
  -- copy module functions
  for _, m in pairs(cls.__modules) do
    for name, func in pairs(m) do
      if name ~= 'included' then
        self[name] = function(...) return func(self, ...) end -- get rid of self for the outside world
      end
    end
  end
  
  -- initialise
  if cls.init then cls.init(self, ...) end
  -- TODO: metamethods
  
  -- all done!
  return self
end

-- Object.new
function Object.new(...)
  return Object._new(Object, ...)
end

-- Object.include
function Object.include(module, ...)
  Object.__modules[module] = module
  if module.included then module.included(Object, ...) end
  return Object
end

-- class creation
function class(name, super, init)
  -- create the inital class object
  local cls = {
    superclass = super,
    init = init
  }
  
  -- set the attributes appropriately if a super class isn't specified
  if not super or type(super) == 'function' then
    cls.superclass = Object
    cls.init = super
  end
  
  -- set the init function to the superclass' init if not specified
  if not cls.init then cls.init = cls.superclass.init end
  
  -- copy everything, except superclass and init from the super class
  for k, v in pairs(cls.superclass) do
    if k ~= '_new' and k ~= 'superclass' and k ~= 'init' then
      cls[k] = v
    end
  end
  
  -- now set everything else needed to right values
  -- we don't set modules because we want to inherit those
  cls.subclasses = {}
  cls.name = name
  cls.__closureClass = true
  
  -- set its metatable
  setmetatable(cls, {
    __tostring = function() return 'class ' .. cls.name end,
    __call = function(_, ...) return cls.new(...) end
  })
  
  -- create the new function
  function cls.new(...)
    return Object._new(cls, ...)
  end
  
  -- create the included function
  function cls.include(module, ...)
    cls.__modules[module] = module
    if module.included then module.included(cls, ...) end
    return cls
  end
  
  -- add class to classes and subclasses
  _classes[name] = cls
  cls.superclass.subclasses[name] = cls
    
  -- call subclassed
  if cls.superclass.subclassed then
    cls.superclass.subclassed(cls)
  end
  
  -- all done!
  return cls
end

-- Helper functions
function isClass(obj)
  return type(obj) == 'table' and obj.__closureClass == true and _classes[obj.name] == obj
end

function subclassOf(other, class)
  if not isClass(other)
     or not isClass(class)
     or not class.superclass
  then
    return false
  end
  
  return class.superclass == other or subclassOf(other, class.superclass)
end

function instanceOf(class, obj)
  if type(obj) ~= 'table'
     or not isClass(class)
     or not isClass(obj.class)
  then
    return false
  end
  
  if obj.class == class then return true end
  return subclassOf(class, obj.class)
end

function includes(module, class)
  if not isClass(class) then return false end
  return class.__modules[module] == module or includes(module, class.superclass)
end