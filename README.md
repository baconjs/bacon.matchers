Matcher library for [Bacon.js](https://github.com/raimohanska/bacon.js).

You can map a Property / EventStream to a `boolean` one like using `.is()`

    // Returns a Property of Booleans
    age.is().equalTo(65)
    salary.is().greaterThan(1000)

You can also filter using `.where()`

    // Returns a filtered stream
    keyUps.map(".keyCode").where().equalTo(30)

And there's negation

    age.is().not().greaterThan(18)

You can compare to either constant values or other Observables. Like

    // Returns a Property of Booleans
    var collision = playerPos.is().equalTo(monsterPos)

You can give field extractor strings to .where() and .is(), like this:

	Bacon.fromArray([
		{ name: "2001: A Space Odyssey", tags: ["SciFi"] },
		{ name: "The Godfather", tags: ["Crime", "Drama"] },
	]).where('.tags').containerOf("SciFi")

	=> { name: "2001: A Space Odyssey", tags: ["SciFi"] }

	Bacon.fromArray([
		{ name: "2001: A Space Odyssey", tags: ["SciFi"] },
		{ name: "The Godfather", tags: ["Crime", "Drama"] },
	]).is('.tags.length').greaterThan(1)

	=> false, true

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


`containerOf(x)` and `memberOf(x)` support arrays, strings and object key-values. Examples:

```javascript
stream = Bacon.once([6]).is().containerOf(6) // is true
stream = Bacon.once(6).is().memberOf([6]) // is true

Bacon.once('hello bacon').is().containerOf('bacon') // is true
Bacon.once('bacon').is().memberOf('hello bacon') // is true

Bacon.once({
  alien: 'morninglightmountain'
  human: 'dudleybose'
}).is().containerOf({ alien: 'morninglightmountain' }) // is true

Bacon.once({ alien: 'morninglightmountain' })
  .is().memberOf({
  alien: 'morninglightmountain'
  human: 'dudleybose'
}) // is true
```


## Browser support

IE 9 and above.

## Download / Install

- Download [javascript file](https://raw.github.com/raimohanska/bacon.matchers/master/bacon.matchers.js)
- NPM: registered as `bacon.matchers`
- Bower: registered as `bacon.matchers`

## Tests

Tests are located in the spec directory. You can run them by installing dependencies with `npm install` and then executing the `run-tests` script.
