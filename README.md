Matcher library for [Bacon.js](https://github.com/raimohanska/bacon.js).

You can map a Property / EventStream to a `boolean` one like using `.is()`

    age.is().equalTo(65)
    salary.is.greaterThan(1000)

You can also filter using `.where()`

    keyUps.map(".keyCode").where().equalTo(30)

And there's negation

    age.is().not().greaterThan(18)


