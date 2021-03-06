((root, factory) ->
  if typeof define is "function" and define.amd
    define factory
  else
    root.Dumper = factory()
  return
) this, ->
  openingTmpl = (bracket) ->
    "\n<div class='dumper__item'>$1<b>#{bracket}</b>$2<span class='dumper__toggle'></span><span class='dumper__ellipsis'>...</span><div class='dumper__item-i'>\n"

  closingTmpl = (bracket) ->
    "\n</div>$1<b>#{bracket}</b>$2</div>\n"

  controlsTmpl = ->
    '<a href="#" class="dumper__control dumper__collapse-all">Collapse all</a> <a href="#" class="dumper__control dumper__expand-all">Expand all</a> '

  $ = (selector, root) ->
    Array::slice.call ((root || document).querySelectorAll selector), 0

  class Dumper
    constructor: (@elem) ->
      @elemContent = @elem.querySelector '.dumper__i'
      @rawData = @elemContent.textContent
      @data = @formatData @rawData

      @buildUI()
      @bindEvents()

    buildUI: ->
      #formatted data
      @elemContent.innerHTML = @data

      #controls
      @controlsWrap = document.createElement 'div'
      @controlsWrap.className = 'dumper__controls'
      @controlsWrap.innerHTML = controlsTmpl()
      @elemContent.insertBefore @controlsWrap, @elemContent.firstChild

      #empty arrays shouldn't bother us
      (elem.parentNode.classList.add('dumper__item_empty') if !elem.innerHTML) for elem in $('.dumper__item-i', @elemContent)

    bindEvents: ->
      #bind listeners
      (
        elem.addEventListener('click', this)
        elem.addEventListener('mouseover', this)
        elem.addEventListener('mouseout', this)
      ) for elem in $('.dumper__toggle', @elemContent)

      $('.dumper__expand-all', @elemContent)[0].addEventListener 'click', @expandAll.bind this
      $('.dumper__collapse-all', @elemContent)[0].addEventListener 'click', @collapseAll.bind this


    formatData: (data) ->
      return data
        #dumb hack shit
        .replace /^(.*)/g, "\n$1"
        #stupid sub, there should be a better way
        .replace /\" sub {/, '"'
        #empty hashes and arrays
        .replace /\{\}/g, '{\n}'
        .replace /\[\]/g, '[\n]'
        #for people who dump unencoded json strings
        .replace /\{([^}{[]]*)\}/g, '{\n$1\n}'
        .replace /\[([^][{}]*)\]/g, '[\n$1\n]'
        #arrays
        .replace /(.*)\[(.*)/g, openingTmpl '['
        .replace /(.*)\](.*)/g, closingTmpl ']'
        #objects
        .replace /(.*)\{(.*)/g, openingTmpl '{'
        .replace /(.*)\}(.*)/g, closingTmpl '}'
        #clean whitespace
        .replace />\s</, "><"
        .replace /[^\n\S]{2,}/g, ""
        .replace /\s{2,}/g, ""

    handleEvent: (e) ->
      e.preventDefault()
      e.stopPropagation()
      switch e.type
        when 'mouseout', 'mouseover' then @toggleHover e.target.parentNode
        when 'click'
          if e.altKey
            @toggleChildren e.target.parentNode
          else
            @toggleItem e.target.parentNode

    expandAll: (e) ->
      e.preventDefault()
      #dont close/open first level
      @expandItem item for item in $('.dumper__item', @elem).slice 1

    collapseAll: (e) ->
      e.preventDefault()
      @collapseItem item for item in $('.dumper__item', @elem).slice 1

    toggleHover: (target) ->
      target.classList.toggle "dumper__item_state_hovered"

    toggleItem: (target) ->
      target.classList.toggle "dumper__item_state_closed"

    collapseItem: (target) ->
      target.classList.add "dumper__item_state_closed"

    expandItem: (target) ->
      target.classList.remove "dumper__item_state_closed"

    toggleChildren: (target) ->
      elems = $('.dumper__item', target)
      #first item open?
      doWeClose = !elems[0].classList.contains 'dumper__item_state_closed'

      #is the clicked item is closed then we open it
      #otherwise there's no point
      if target.classList.contains 'dumper__item_state_closed' then @toggleItem target
      if doWeClose
        @collapseItem item for item in elems
      else
        @expandItem item for item in elems

  #auto init
  new Dumper(elem) for elem in $ ".dumper"

  return Dumper

