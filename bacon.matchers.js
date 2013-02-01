Bacon.Observable.prototype.is = function() {
  return this
}
Bacon.Observable.prototype.in = function(list) {
  return this.map(function(v) { return Bacon._.contains(list, v) })
}
Bacon.Observable.prototype.equalTo = function(test) {
  return this.map(function(v) { return v === test })
}
