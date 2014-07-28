init = (Bacon) ->
  toFieldExtractor = (f) ->
    parts = f.slice(1).split(".")
    partFuncs = Bacon._.map(toSimpleExtractor, parts)
    (value) ->
      for f in partFuncs
        value = f(value)
      value
  toSimpleExtractor = (key) -> (value) ->
    if not value?
      undefined
    else
      value[key]
  contains = (container, item) ->
    if container instanceof Array or typeof container == 'string'
      container.indexOf(item) >= 0
    else if typeof container == 'object'
      matchingKeyValuePairs = 0
      Object.keys(item).forEach (bKey) -> # Object.keys works in IE9 and above
        containerHasItemKeyAndValue = container.hasOwnProperty(bKey) and container[bKey] == item[bKey]
        if containerHasItemKeyAndValue
          matchingKeyValuePairs += 1
      containerHasAllKeyValuesOfItem = matchingKeyValuePairs == Object.keys(item).length
      itemIsNotEmpty = Object.keys(item).length > 0
      containerHasAllKeyValuesOfItem and itemIsNotEmpty
    else
      false


  addMatchers = (apply1, apply2, apply3) ->
    context = addPositiveMatchers apply1, apply2, apply3
    context["not"] = ->
      applyNot1 = (f) -> apply1 (a) -> not f(a)
      applyNot2 = (f) -> apply2 (a, b) -> not f(a, b)
      applyNot3 = (f) -> apply3 (val, a, b) -> not f(val, a, b)
      addPositiveMatchers applyNot1, applyNot2, applyNot3
    context

  addPositiveMatchers = (apply1, apply2, apply3) ->
    context = {}
    context["lessThan"] = apply2((a, b) ->
      a < b
    )
    context["lessThanOrEqualTo"] = apply2((a, b) ->
      a <= b
    )
    context["greaterThan"] = apply2((a, b) ->
      a > b
    )
    context["greaterThanOrEqualTo"] = apply2((a, b) ->
      a >= b
    )
    context["equalTo"] = apply2((a, b) ->
      a is b
    )
    context["truthy"] = apply1((a) ->
      !!a
    )
    context["match"] = apply2((val, pattern) ->
      pattern.test val
    )
    context["inOpenRange"] = apply3((val, a, b) ->
      a < val < b
    )
    context["inClosedRange"] = apply3((val, a, b) ->
      a <= val <= b
    )
    context["containerOf"] = apply2((a, b) ->
      contains(a,b)
    )
    context["memberOf"] = apply2((a, b) ->
      contains(b,a)
    )

    context
  asMatchers = (operation, combinator, fieldKey) ->
        field = if fieldKey? then toFieldExtractor(fieldKey) else Bacon._.id
        apply1 = (f) ->
          ->
            operation (val) -> f(field(val))
        apply2 = (f) ->
          (other) ->
            if other instanceof Bacon.Observable
              combinator other, (val, other) -> f(field(val), other)
            else
              operation (val) -> f(field(val), other)
        apply3 = (f) ->
          (first, second) ->
            operation (val) -> f(field(val), first, second)
        addMatchers apply1, apply2, apply3
  Bacon.Observable::is = (fieldKey) ->
    context = this
    operation = (f) -> context.map(f)
    combinator = (observable, f) -> context.combine(observable, f)
    asMatchers(operation, combinator, fieldKey)
  Bacon.Observable::where = (fieldKey) ->
    context = this
    operation = (f) -> context.filter(f)
    combinator = (observable, f) -> context.filter context.combine(observable, f)
    asMatchers(operation, combinator, fieldKey)
  Bacon

if module?
  Bacon = require("baconjs")
  module.exports = init(Bacon)
else
  if typeof require is "function"
    define "bacon.matchers", ["bacon"], init
  else
    init(this.Bacon)
