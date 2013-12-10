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
`greaterThan(x)` applies `>´ matcher
`equalTo(x)` applies `==` matcher
`truthy()` applies "truthy" matcher
`not()` returns a negated `Matchers` object
