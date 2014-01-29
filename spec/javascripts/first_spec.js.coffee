expectedFailures = expectedErrors = expectedTimeouts = 0

oojspec.describe "First spec", ->
  b1 = b2 = a1 = a2 = 0
  @before -> ++b1
  @before -> ++b2
  @after ->  ++a1
  @after ->  ++a2

  @example 'pass with 2 assertions', ->
    @expect(true).toBe true
    @assert true

  expectedFailures++
  @example 'fail with one assertion', ->
    @assert false
    throw 'should never be executed'

  @describe 'inner describe', -> @it 'passes', -> @assert true

  expectedErrors++
  @context 'inner context', -> @it 'throws', ->
    @describe "describe shouldn't be available here"

  expectedTimeouts++
  expectedFailures++
  @it 'times out', ->
    @waitsFor "waiting for false - will never run", 30, -> false
    @runs -> throw "Should never get here"

  @it 'does not time out', ->
    a = false
    setTimeout (-> a = true), 100
    @waitsFor -> a
    @runs -> @assert true

  @specify "before and after work", ->
    @expect(b1).toBe 7
    @expect(b2).toBe 7
    @expect(a1).toBe 6
    @expect(a2).toBe 6

  @specify "this should be the last test and pass", ->
    @expect(parent.oojspec.stats.failures).toBe expectedFailures
    @expect(parent.oojspec.stats.errors).toBe expectedErrors
    @expect(parent.oojspec.stats.timeouts).toBe expectedTimeouts
    # top-level describes: 'First spec', 'Second context', 'After all description',
    # 'Bare class', 'JavaScript-like with binding', 'Regular describe and OO' and
    # 'Regular describe and OO with bare set up'
    @expect(parent.oojspec.stats.contexts).toBe 7
