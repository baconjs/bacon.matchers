Matcher library for [Bacon.js](https://github.com/raimohanska/bacon.js).

You can map a Property / EventStream to a `boolean` one like using `.is()`

    // Returns a Property of Booleans
    age.is().equalTo(65)
    salary.is.greaterThan(1000)

You can also filter using `.where()`

    // Returns a filtered stream
    keyUps.map(".keyCode").where().equalTo(30)

And there's negation

    age.is().not().greaterThan(18)
    
You can compare to either constant values or other Observables. Like

    // Returns a Property of Booleans
    var collision = playerPos.is().equalTo(monsterPos)    
    
Complete examples:

    Bacon.fromArray([1,2,3]).is().equalTo(2)
    
    => false, true, false
    
    Bacon.fromArray([1,2,3]).where().equalTo(2)
    
    => 2

## Additions to Observable API

`Observable.is()` returns a `Matchers` object for mapping to booleans.

`Observable.where()` returns a `Matchers` object for filtering.

## Matchers API

`lessThan(x)` applies `<` matcher

`lessThanOrEqualTo(x)` applies `<=` matcher

`greaterThan(x)` applies `>` matcher

`greaterThanOrEqualTo` applies `>=` matcher

`inClosedRange(a, b)` applies `[a..b]` range matcher

`inOpenRange(a, b)` applies `(a..b)` range matcher

`equalTo(x)` applies `==` matcher

`truthy()` applies "truthy" matcher

`match(expr)` applies `regular expression` matcher

`not()` returns a negated `Matchers` object

## Download / Install

- Download [javascript file](https://raw.github.com/raimohanska/bacon.matchers/master/bacon.matchers.js)
- NPM: registered as `bacon.matchers`
- Bower: registered as `bacon.matchers`

## Tests

Tests are located in the spec directory. You can run them by installing dependencies with `npm install` and then executing the `run-tests` script.
