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
    it 'should filter with when()', (done) ->
      stream = Bacon.fromArray(["hey", "Hi", "ho", "HoWdy"]).where().match(/^[a-z]+$/)
      assertValues ["hey", "ho"], stream, done
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

