init = (Bacon) ->
  addMatchers = (apply1, apply2) ->
    context = addPositiveMatchers apply1, apply2
    context["not"] = ->
      applyNot1 = (f) -> apply1 (a) -> not f(a)
      applyNot2 = (f) -> apply2 (a, b) -> not f(a, b)
      addPositiveMatchers applyNot1, applyNot2
    context

  addPositiveMatchers = (apply1, apply2) ->
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
    context
  Bacon.Observable::is = ->
    apply1 = (f) ->
      ->
        observable.map f
    apply2 = (f) ->
      (other) ->
        if other instanceof Bacon.Observable
          observable.combine other, f
        else
          observable.map (val) -> f(val, other)
    observable = this
    addMatchers apply1, apply2

  Bacon.Observable::where = ->
    apply1 = (f) ->
      ->
        observable.filter f
    apply2 = (f) ->
      (other) ->
        if other instanceof Bacon.Observable
          isMatch = observable.combine(other, f)
          observable.filter isMatch
        else
          observable.filter (val) -> f(val, other)
    observable = this
    addMatchers apply1, apply2

if module?
  Bacon = require("baconjs")
  module.exports = init(Bacon)
else
  if typeof require is "function"
    define "bacon.matchers", ["bacon"], init
  else
    init(this.Bacon)
