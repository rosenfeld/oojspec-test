oojspec.describe class
  @description: 'Bare class'
  @bare: true

  self = null

  runSpecs: (dsl)->
    self = this
    @dialog = dialog: true
    dsl.example 'this in example is this instance', @exampleTest
    dsl.context 'this in contexts is this instance too', @contextTest
    dsl.describe NonBareClass

  exampleTest: (s)->
    s.expect(this).toBe self
    s.expect(@dialog).toEqual dialog: true

  contextTest: (s)->
    s.example 'inline sub-context example', (s)-> s.expect(this).toBe self
    s.example 'inner example has same this', @exampleTest

class NonBareClass
  self = null

  runSpecs: ->
    self = this
    @dialog = dialog: true
    @example 'this in example is this instance', @exampleTest
    @context 'this in contexts is this instance too', @contextTest

  exampleTest: ->
    @expect(this).toBe self
    @expect(@dialog).toEqual dialog: true

  contextTest: ->
    @example 'inline sub-context example', -> @refute @example
    @example 'inner example has same this', @exampleTest

plain =
  description: 'JavaScript-like with binding'
  dialog: {dialog: true}
  runSpecs: -> this.example('JavaScript-like example', this.sampleExample)
  sampleExample: -> this.assert(this.dialog.dialog)

describe plain

# or just use "this" in a regular describe, although not much useful:

describe "Regular describe and OO", ->
  @example "'this' is propagated", ->
    @expect(@helper()).toBe 1
  @helper = -> 1

describe "Regular describe and OO with bare set up", ->
  @bare = true
  @timeout = 100
  @example "'this' is propagated but DSL is not injected", (s)->
    s.expect(@timeout).toBe 100
    s.refute @expect
