assert = require("assert")
Bacon = require("../bacon.matchers")

assertConstantly = (expectedValue, stream, done) ->
  stream.onValue (val) -> assert.equal expectedValue, val
  stream.onEnd done

describe 'bacon.matchers', ->
  describe '#is()', ->
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

