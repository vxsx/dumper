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

  parseData: (data) ->
    return data
      #dumb hack shit
      .replace(/\" sub {/, '"')
      #arrays
      .replace /\[(\s*)\n/g, "[<div class='dumper__array dumper__item'>#{toggleTmpl}#{ellipsis}<div class='dumper__item-i'>"
      .replace /\n(\s*)\]/g, "</div></div>$1]"
      #objects
      .replace /\{(\s*)\n/g, "{<div class='dumper__object dumper__item'>#{toggleTmpl}#{ellipsis}<div class='dumper__item-i'>"
      .replace /\n(\s*)\}/g, "</div></div>$1}"
      #clean whitespace
      .replace /[^\n\S]{2,}/g, ""

  toggleBlock: (e) ->
    e.preventDefault()
    e.stopPropagation()

    clicked = e.target
    console.log clicked.parentNode
    clicked.parentNode.classList.toggle 'dumper__item_state_closed'

window.dumper = new Dumper(elem) for elem in document.querySelectorAll ".dumper"

