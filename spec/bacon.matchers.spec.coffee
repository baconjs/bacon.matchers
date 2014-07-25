assert = require("assert")
Bacon = require("../bacon.matchers.js") # Test the result of the build

assertConstantly = (expectedValue, stream, done) ->
  stream.onValue (val) -> assert.equal expectedValue, val
  stream.onEnd done

assertValues = (expectedValues, stream, done) ->
  foldedValues = stream.fold [], (values, newValue) ->
    values.concat(newValue)
  foldedValues.onValue (receivedValues) ->
    assert.deepEqual expectedValues, receivedValues
  foldedValues.onEnd ->
    done()

describe 'bacon.matchers', ->
  describe 'structure', ->
    it 'should return same matchers for is and where', ->
      stream = Bacon.once(1)
      isMatchers = Object.keys(stream.is()).join()
      whereMatchers = Object.keys(stream.where()).join()
      assert.equal isMatchers, whereMatchers
  describe 'basic functionality', ->
    it 'should map to booleans with is()', (done) ->
      stream = Bacon.fromArray([1, 2, 1, 3]).is().equalTo(1)
      assertValues [true, false, true, false], stream, done
    it 'should filter with where()', (done) ->
      stream = Bacon.fromArray(["hey", "Hi", "ho", "HoWdy"]).where().match(/^[a-z]+$/)
      assertValues ["hey", "ho"], stream, done
    it 'should filter by key with where(".key")', (done) ->
      stream = Bacon.fromArray([
        {title: 'The Machine',     tags: ['SciFi', 'Thriller']},
        {title: 'Captain America', tags: ['SciFi', 'Action']},
        {title: 'The Hobbit',      tags: ['Fantasy', 'Adventure']},
        {title: 'Frozen',          tags: ['Family', 'Adventure']}]
      ).where('.tags').containerOf('SciFi')

      assertValues [
        {title: 'The Machine',     tags: ['SciFi', 'Thriller']},
        {title: 'Captain America', tags: ['SciFi', 'Action']}
      ], stream, done
    it 'should map by key with is(".key)"', (done) ->
      isValid = Bacon.fromArray([
        {title: 'The Godfather',            tags: ['Crime', 'Drama']},
        {title: 'Europa Report',            tags: ['SciFi']},
        {title: 'The Grand Budapest Hotel', tags: []}]
      ).is('.tags.length').greaterThan(0)
      
      assertValues [true, true, false], isValid, done
  describe 'matchers', ->
    describe 'equalTo', ->
      it 'compares equal values correctly', (done) ->
        strs = ["bacon.js", "ponyfood.js"]
        stream = Bacon.fromArray(strs).is().equalTo("ponyfood.js")
        assertValues [false, true], stream, done
    describe 'lessThanOrEqualTo', ->
      it '5 <= 5', (done) ->
        stream = Bacon.once(5).is().lessThanOrEqualTo(5)
        assertConstantly true, stream, done
      it '1 <= 5', (done) ->
        stream = Bacon.once(1).is().lessThanOrEqualTo(5)
        assertConstantly true, stream, done
      it '6 not <= 5', (done) ->
        stream = Bacon.once(6).is().lessThanOrEqualTo(5)
        assertConstantly false, stream, done
    describe 'greaterThanOrEqualTo', ->
      it '5 >= 5', (done) ->
        stream = Bacon.once(5).is().greaterThanOrEqualTo(5)
        assertConstantly true, stream, done
      it '6 >= 5', (done) ->
        stream = Bacon.once(6).is().greaterThanOrEqualTo(5)
        assertConstantly true, stream, done
      it '1 not >= 5', (done) ->
        stream = Bacon.once(1).is().greaterThanOrEqualTo(5)
        assertConstantly false, stream, done
    describe 'match', ->
      expr = /^[a-z]{6}$/i
      it 'should match with regexp and correct string', (done) ->
        stream = Bacon.once('foobar').is().match(expr)
        assertConstantly true, stream, done
      it 'should not match not matching string', (done) ->
        stream = Bacon.once('foobarzzz').is().match(expr)
        assertConstantly false, stream, done
    describe 'inOpenRange', ->
      it 'should return true with values within range', (done) ->
        stream = Bacon.fromArray([8,12,18]).is().inOpenRange(7, 19)
        assertConstantly true, stream, done
      it 'should return false with values not within range', (done) ->
        stream = Bacon.fromArray([7,-5,19]).is().inOpenRange(7, 19)
        assertConstantly false, stream, done
    describe 'inClosedRange', ->
      it 'should return true with values within range', (done) ->
        stream = Bacon.fromArray([7,18,19]).is().inClosedRange(7, 19)
        assertConstantly true, stream, done
      it 'should return false with values not within range', (done) ->
        stream = Bacon.fromArray([6,20]).is().inClosedRange(7, 19)
        assertConstantly false, stream, done
    describe 'containerOf', ->
      context 'value is an array', ->
        it 'should return true when the array contains the element', (done) ->
          stream = Bacon.once([6]).is().containerOf(6)
          assertConstantly true, stream, done
        it 'should return false when the array does not contain the element', (done) ->
          stream = Bacon.once([66]).is().containerOf(6)
          assertConstantly false, stream, done
      context 'value is a string', ->
        it 'should return true when the string contains the sub-string', (done) ->
          stream = Bacon.once('hello bacon').is().containerOf('bacon')
          assertConstantly true, stream, done
        it 'should return false when the string does not contain the sub-string', (done) ->
          stream = Bacon.once('hello bacon').is().containerOf('Bacon')
          assertConstantly false, stream, done
      context 'value is an object', ->
        it 'should return true when the object contains the key-value pair', (done) ->
          stream = Bacon.once({
            alien: 'morninglightmountain'
            human: 'dudleybose'
          }).is().containerOf({alien: 'morninglightmountain'})
          assertConstantly true, stream, done
        it 'should return true when comparing equal objects', (done) ->
          object =
            alien: 'morninglightmountain'
          stream = Bacon.once(object).is().containerOf(object)
          assertConstantly true, stream, done
        it 'should return false when key matches but value does not', (done) ->
          stream = Bacon.once(
            alien: 'morninglightmountain'
          ).is().containerOf(alien: 't1000')
          assertConstantly false, stream, done
        it 'should return false when the object contains a subset of the compared value', (done) ->
          stream = Bacon.once(
            alien: 'morninglightmountain'
          ).is().containerOf(
            alien: 'morninglightmountain'
            human: 'dudleybose'
          )
          assertConstantly false, stream, done
        it 'should return false when comparing a non-empty object to {}', (done) ->
          stream = Bacon.once(
            alien: 'morninglightmountain'
          ).is().containerOf( {} )
          assertConstantly false, stream, done
        it 'should return false when comparing {} to {}', (done) ->
          stream = Bacon.once( {} ).is().containerOf( {} )
          assertConstantly false, stream, done
      context 'value is a boolean', ->
        it 'should always return false', (done) ->
          stream = Bacon.once(false).is().containerOf(false)
          assertConstantly false, stream, done
      context 'value is a number', ->
        it 'should always return false', (done) ->
          stream = Bacon.once(1).is().containerOf(1)
          assertConstantly false, stream, done
      context 'value is a function', ->
        it 'should always return false', (done) ->
          fun = ->
          stream = Bacon.once(fun).is().containerOf(fun)
          assertConstantly false, stream, done
    describe 'memberOf', ->
      context 'matcher is an array', ->
        it 'should return true when the array contains the element', (done) ->
          stream = Bacon.once(6).is().memberOf([6])
          assertConstantly true, stream, done
        it 'should return false when the array does not contain the element', (done) ->
          stream = Bacon.once(66).is().memberOf([6])
          assertConstantly false, stream, done
      context 'matcher is a string', ->
        it 'should return true when the string contains the sub-string', (done) ->
          stream = Bacon.once('bacon').is().memberOf('hello bacon')
          assertConstantly true, stream, done
        it 'should return false when the string does not contain the sub-string', (done) ->
          stream = Bacon.once('Bacon').is().memberOf('hello bacon')
          assertConstantly false, stream, done
      context 'matcher is an object', ->
        it 'should return true when the object contains the key-value pair', (done) ->
          stream = Bacon.once({ alien: 'morninglightmountain' }).is().memberOf({
            alien: 'morninglightmountain'
            human: 'dudleybose'
          })
          assertConstantly true, stream, done
        it 'should return true when comparing equal objects', (done) ->
          object =
            alien: 'morninglightmountain'
          stream = Bacon.once(object).is().memberOf(object)
          assertConstantly true, stream, done
        it 'should return false when key matches but value does not', (done) ->
          stream = Bacon.once(
            alien: 'morninglightmountain'
          ).is().memberOf(alien: 't1000')
          assertConstantly false, stream, done
        it 'should return false when the object contains a subset of the compared value', (done) ->
          stream = Bacon.once(
            alien: 'morninglightmountain'
            human: 'dudleybose'
          ).is().memberOf(
            alien: 'morninglightmountain'
          )
          assertConstantly false, stream, done
        it 'should return false when comparing a non-empty object to {}', (done) ->
          stream = Bacon.once({}).is().memberOf(
            alien: 'morninglightmountain'
          )
          assertConstantly false, stream, done
        it 'should return false when comparing {} to {}', (done) ->
          stream = Bacon.once( {} ).is().memberOf( {} )
          assertConstantly false, stream, done
      context 'matcher is a boolean', ->
        it 'should always return false', (done) ->
          stream = Bacon.once(false).is().memberOf(false)
          assertConstantly false, stream, done
      context 'matcher is a number', ->
        it 'should always return false', (done) ->
          stream = Bacon.once(1).is().memberOf(1)
          assertConstantly false, stream, done
      context 'matcher is a function', ->
        it 'should always return false', (done) ->
          fun = ->
          stream = Bacon.once(fun).is().memberOf(fun)
          assertConstantly false, stream, done