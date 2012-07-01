expectedContexts = expectedFailures = expectedErrors = expectedTimeouts = 0

expectedContexts++
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
    @assert true

  expectedContexts++
  @describe 'inner describe', -> @it 'passes', -> @assert true

  expectedContexts++
  expectedErrors++
  @context 'inner context', -> @it 'throws', ->
    @describe "describe shouldn't be available here"

  expectedTimeouts++
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
    @expect(oojspec.stats.failures).toBe expectedFailures
    @expect(oojspec.stats.errors).toBe expectedErrors
    @expect(oojspec.stats.timeouts).toBe expectedTimeouts
    @expect(oojspec.stats.contexts).toBe expectedContexts
