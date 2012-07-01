b = bAll = a = aAll = 0
describe "Second context", ->
  @pending 'pending example'

  @it 'works with async steps', ->
    waiting = true
    setTimeout (-> waiting = false), 20
    @waitsFor -> not waiting
    @runs -> @refute waiting

  @before 'first before', -> throw 'unexpected' unless a is b++
  @before -> throw 'unexpected' unless b > 0
  @beforeAll -> throw 'unexpected' unless aAll is bAll++
  @after 'after', -> throw 'unexpected' unless ++a is b
  @afterAll 'afterAll', -> throw 'unexpected' unless ++aAll is bAll

  @example "before/after hooks work", ->
    @expect(b).toBe 2
    @expect(a).toBe 1
    @expect(bAll).toBe 1
    @expect(aAll).toBe 0

oojspec.describe "After all description", ->
  @example 'afterAll works', ->
    @expect(a).toBe 2
    @expect(aAll).toBe 1
