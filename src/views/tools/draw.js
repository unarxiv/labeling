export default {
  vector (name) {
    let _el = document.createElementNS('http://www.w3.org/2000/svg', name)
    return _el
  },
  setAttr (el, attr) {
    attr = attr || {}
    let i
    for (i in attr) {
      if (attr.hasOwnProperty(i)) {
        el.setAttribute(i, attr[i])
      }
    }
  },
  getAttr (el, scale) {
    let attr = el.attributes
    let _attr = {}
    let _type = el.nodeName
    let i
    for (i in attr) {
      if (attr.hasOwnProperty(i)) {
        _attr[attr[i].name] = attr[i].value
      }
    }
    switch (_type) {
      case 'rect':
        _attr.x = _attr.x / scale
        _attr.y = _attr.y / scale
        _attr.width = _attr.width / scale
        _attr.height = _attr.height / scale
        _attr['stroke-width'] = _attr['stroke-width'] / scale
        break
      case 'polyline':
        _attr['stroke-width'] = _attr['stroke-width'] / scale
        _attr.points = this.fitPoints(_attr.points, scale)
        break
    }
    return {
      type: _type,
      attr: _attr
    }
  },
  pointsToString (points) {
    let p = []
    points.forEach(element => {
      p.push(element.x + ',' + element.y)
    })
    return p.join(' ')
  },
  fitSize (imgW, imgH, w, h) {
    let size = {w: 0, h: 0}
    if (imgW <= w && imgH <= h) {
      size.w = imgW
      size.h = imgH
    } else {
      if (imgW / imgH < w / h) {
        size.h = Math.min(imgH, h)
        size.w = imgW * size.h / imgH
      } else {
        size.w = Math.min(imgW, w)
        size.h = imgH * size.w / imgW
      }
    }
    return size
  },
  fitPoints (points, scale) {
    let ps = points.split(' ')
    let _ps = []
    ps.forEach(i => {
      let ips = i.split(',')
      _ps.push(
        {
          x: ips[0] / scale,
          y: ips[1] / scale
        }
      )
    })
    return this.pointsToString(_ps)
  },
  fitAttr (attr, type, scale) {
    scale = 1 / scale
    let _attr = {}
    let i
    for (i in attr) {
      if (attr.hasOwnProperty(i)) {
        _attr[i] = attr[i]
      }
    }
    switch (type) {
      case 'rect':
        _attr.x = _attr.x / scale
        _attr.y = _attr.y / scale
        _attr.width = _attr.width / scale
        _attr.height = _attr.height / scale
        _attr['stroke-width'] = _attr['stroke-width'] / scale
        break
      case 'polyline':
        _attr.points = this.fitPoints(_attr.points, scale)
        _attr['stroke-width'] = _attr['stroke-width'] / scale
        break
    }
    return _attr
  },
  getFirstPoint (svg) {
    let p = {x: 0, y: 0}
    switch (svg.nodeName) {
      case 'rect':
        p.x = svg.getAttribute('x') * 1
        p.y = svg.getAttribute('y') * 1
        break
      case 'polyline':
        let point = svg.getAttribute('points').split(' ')[0].split(',')
        p.x = point[0] * 1
        p.y = point[1] * 1
        break
    }
    return p
  },
  getOffset (el) {
    let x, y
    x = el.offsetLeft
    y = el.offsetTop
    while (el.offsetParent) {
      el = el.offsetParent
      x += el.offsetLeft
      y += el.offsetTop
    }
    return {
      x: x * 1,
      y: y * 1
    }
  },
  removeNode (el) {
    if (el && el.parentNode) {
      el.parentNode.removeChild(el)
    }
  }
}
