toggleTmpl = '<span class="dumper__toggle"></span>'
ellipsis = '<span class="dumper__ellipsis">...</span>'

class Dumper
  constructor: (@elem) ->
    @elemContent = @elem.querySelector '.dumper__i'
    @rawData = @elemContent.innerText
    @data = @parseData @rawData

    @buildUI()

  buildUI: ->
    @elemContent.innerHTML = @data

    Array::forEach.call @elemContent.querySelectorAll('.dumper__toggle'), (elem) =>
      elem.addEventListener 'click', @toggleBlock.bind this
      elem.addEventListener 'mouseover', @toggleHover.bind this
      elem.addEventListener 'mouseout', @toggleHover.bind this

  parseData: (data) ->
    return data
      #dumb hack shit
      .replace /^(.*)/g, "\n$1"
      .replace /\{\}/g, '{\n}'
      # .replace /\{(.*)\}/g, '{\n$1\n}'
      .replace /\" sub {/, '"'
      #arrays
      .replace /(.*)\[(.*)/g, "\n<div class='dumper__array dumper__item'>$1<b>[</b>$2#{toggleTmpl}#{ellipsis}<div class='dumper__item-i'>\n"
      .replace /(.*)\](.*)/g, "\n</div>$1<b>]</b>$2</div>\n"
      #objects
      .replace /(.*)\{(.*)/g, "\n<div class='dumper__object dumper__item'>$1<b>{</b>$2#{toggleTmpl}#{ellipsis}<div class='dumper__item-i'>\n"
      .replace /(.*)\}(.*)/g, "\n</div>$1<b>}</b>$2</div>\n"
      #clean whitespace
      .replace /[^\n\S]{2,}/g, ""
      .replace /\s{2,}/g, ""

    #TODO clear empty divs

  toggleBlock: (e) ->
    e.preventDefault()
    e.stopPropagation()
    clicked = e.target
    clicked.parentNode.classList.toggle 'dumper__item_state_closed'

  toggleHover: (e) ->
    e.preventDefault()
    e.stopPropagation()
    hovered = e.target
    hovered.parentNode.classList.toggle 'dumper__item_state_hovered'

window.dumper = new Dumper(elem) for elem in document.querySelectorAll ".dumper"

