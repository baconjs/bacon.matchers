Not much here yet. Will be a great matcher API for bacon.js when grows up.

The idea is to add something like this to [bacon.js](https://github.com/raimohanska/bacon.js)
 
    age.is.equalTo(65)
    salary.is.greaterThan(1000)
    name.matches(/.*Smith/)
    keyUps.when.field("keyCode").isBetween(39,43)
    name.when.value.matches(/.*raimohanska/)

Now there's just

    x.is().equalTo("a")
    x.is().in([1,2,3])

