((root, factory) ->
  if typeof define is "function" and define.amd
    define factory
  else
    root.Dumper = factory()
  return
) this, ->
  openingTmpl = (bracket) ->
    "\n<div class='dumper__array dumper__item'>$1<b>#{bracket}</b>$2<span class='dumper__toggle'></span><span class='dumper__ellipsis'>...</span><div class='dumper__item-i'>\n"

  closingTmpl = (bracket) ->
    "\n</div>$1<b>#{bracket}</b>$2</div>\n"

  $ = (selector, root) ->
    Array::slice.call ((root || document).querySelectorAll selector), 0

  class Dumper
    constructor: (@elem) ->
      @elemContent = @elem.querySelector '.dumper__i'
      @rawData = @elemContent.innerText
      @data = @parseData @rawData

      @buildUI()

    buildUI: ->
      @elemContent.innerHTML = @data

      #bind listeners
      $('.dumper__toggle', @elemContent).forEach (elem) =>
        elem.addEventListener 'click', this
        elem.addEventListener 'mouseover', this
        elem.addEventListener 'mouseout', this

      #empty arrays shouldn't bother us
      $('.dumper__item-i', @elemContent).forEach (elem) ->
        if !elem.innerHTML then elem.parentNode.classList.add 'dumper__item_empty'

    parseData: (data) ->
      return data
        #dumb hack shit
        .replace /^(.*)/g, "\n$1"
        .replace /\{\}/g, '{\n}'
        .replace /\[\]/g, '[\n]'
        .replace /\" sub {/, '"'
        #arrays
        .replace /(.*)\[(.*)/g, openingTmpl '['
        .replace /(.*)\](.*)/g, closingTmpl ']'
        #objects
        .replace /(.*)\{(.*)/g, openingTmpl '{'
        .replace /(.*)\}(.*)/g, closingTmpl '}'
        #clean whitespace
        .replace /[^\n\S]{2,}/g, ""
        .replace /\s{2,}/g, ""


    handleEvent: (e) ->
      e.preventDefault()
      e.stopPropagation()
      switch e.type
        when 'mouseout', 'mouseover' then @toggleItemState e.target, 'hovered'
        when 'click' then @toggleItemState e.target, 'closed'

    toggleItemState: (target, state) ->
      target.parentNode.classList.toggle "dumper__item_state_#{state}"

  #auto init
  new Dumper(elem) for elem in document.querySelectorAll ".dumper"

  return Dumper

