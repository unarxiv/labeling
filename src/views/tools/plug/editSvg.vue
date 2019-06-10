<template>
  <div class="edit-svg">
    <svg ref="edit_canvas" width="100%" height="100%"
      @mousedown="down"
      @mousemove="move"
      @mouseout="out"
      @mouseup="up"/>
    <div class="edit-svg-tools" ref="edit_tools">
      <ButtonGroup>
        <Button type="primary" size="small" @click="cancel" title="取消">
            <Icon type="close-round"></Icon>
        </Button>
        <Button type="primary" size="small" @click="save" title="保存">
            <Icon type="checkmark-round"></Icon>
        </Button>
      </ButtonGroup>
    </div>
  </div>
</template>
<script>
import Draw from '../draw'
export default {
  name: 'editSvg',
  data () {
    return {
      type: '',
      vector: null,
      x: 0,
      y: 0,
      drag: false,
      index: 0,
      deltaX: 0,
      deltaY: 0,
      circles: {},
      deltaAttr: {}
    }
  },
  methods: {
    edit (vector) {
      let vec = Draw.getAttr(vector, 1)
      this.type = vec.type
      this.vector = vector
      this.deltaAttr = vec.attr
      switch (vec.type) {
        case 'rect':
          this.editRect()
          break
        case 'polyline':
          this.editPolyline()
          break
      }
    },
    editRect () {
      let vector = this.vector
      let vec = Draw.getAttr(vector, 1)
      let editCanvas = this.$refs.edit_canvas
      let editTools = this.$refs.edit_tools
      let lineWidth = 7
      let width = vec.attr.width + 2 * lineWidth
      let height = vec.attr.height + 2 * lineWidth
      let x = vec.attr.x - lineWidth
      let y = vec.attr.y - lineWidth
      this.$nextTick(() => {
        if (x + width + 50 > editCanvas.parentElement.offsetWidth) {
          editTools.style.left = (x + width - 50) + 'px'
        } else {
          editTools.style.left = (x + width) + 'px'
        }
        editTools.style.top = (y + lineWidth) + 'px'
      })

      if (!this.drag) {
        // editCanvas.innerHTML = ''
        while (editCanvas.childNodes.length > 0) {
          editCanvas.removeChild(editCanvas.firstChild)
        }
      }
      editCanvas.style.cursor = 'default'
      for (let i = 0; i < 9; i++) {
        // if (i === 4) continue
        let circle = this.circles[i] || Draw.vector('circle')
        Draw.setAttr(circle, {
          'cx': x + (i % 3) * (width - 2 * lineWidth) / 2 + lineWidth,
          'cy': y + Math.floor(i / 3) * (height - 2 * lineWidth) / 2 + lineWidth,
          'r': lineWidth - 1,
          'stroke': 'black',
          'stroke-width': 1,
          'fill': '#2db7f5',
          'data-index': i,
          'style': 'cursor:' + this.rectCusor(i)
        })
        editCanvas.appendChild(circle)
        this.circles[i] = circle
      }
    },
    editPolyline () {
      let vector = this.vector
      let vec = Draw.getAttr(vector, 1)
      let editCanvas = this.$refs.edit_canvas
      let editTools = this.$refs.edit_tools
      let lineWidth = 7
      let points = vec.attr.points.split(' ')
      let rect = this.comRect(points)
      let width = rect.width + lineWidth
      // let height = rect.height + 2 * lineWidth
      let x = rect.x - lineWidth
      let y = rect.y - lineWidth
      this.$nextTick(() => {
        if (x + width + 50 > editCanvas.parentElement.offsetWidth) {
          editTools.style.left = (x + width - 50) + 'px'
        } else {
          editTools.style.left = (x + width) + 'px'
        }
        editTools.style.top = (y + lineWidth) + 'px'
      })

      if (!this.drag) {
        // editCanvas.innerHTML = ''
        while (editCanvas.childNodes.length > 0) {
          editCanvas.removeChild(editCanvas.firstChild)
        }
      }
      editCanvas.style.cursor = 'default'

      for (let i = 0; i < points.length - 1; i++) {
        let circle = this.circles[i] || Draw.vector('circle')
        let point = points[i].split(',')
        Draw.setAttr(circle, {
          'cx': point[0],
          'cy': point[1],
          'r': lineWidth - 1,
          'stroke': 'black',
          'stroke-width': 1,
          'fill': '#2db7f5',
          'data-index': i,
          'style': 'cursor:default'
        })
        editCanvas.appendChild(circle)
        this.circles[i] = circle
      }
    },
    down (e) {
      e.preventDefault()
      e.stopPropagation()
      // console.log('down')
      let vector = e.target
      let attr = Draw.getAttr(vector, 1)
      if (attr.type === 'circle') {
        this.drag = true
        this.x = e.clientX
        this.y = e.clientY
        this.index = attr.attr['data-index']
      }
    },
    move (e) {
      e.preventDefault()
      e.stopPropagation()
      if (this.drag) {
        this.deltaX = e.clientX - this.x
        this.deltaY = e.clientY - this.y
        this.x = e.clientX
        this.y = e.clientY
        this.reSize()
      }
    },
    out (e) {
      e.preventDefault()
      e.stopPropagation()
      if (this.isOut(e)) {
        this.drag = false
      }
    },
    up (e) {
      // console.log('up')
      e.preventDefault()
      e.stopPropagation()
      this.drag = false
    },
    rectCusor (i) {
      let data = {
        0: 'nw-resize',
        1: 'n-resize',
        2: 'ne-resize',
        3: 'w-resize',
        4: 'move',
        5: 'e-resize',
        6: 'sw-resize',
        7: 's-resize',
        8: 'se-resize'
      }
      return data[i]
    },
    reSize () {
      switch (this.type) {
        case 'rect':
          this.rectReSize()
          break
        case 'polyline':
          this.polylineReSize()
          break
      }
    },
    rectReSize () {
      let index = +this.index
      // let box = this.$refs.edit_canvas
      let vector = this.vector
      let vec = Draw.getAttr(vector, 1)
      let attr = Object.assign({}, vec.attr)
      let minWidth = 10
      let minHeight = 10
      let initalX = vec.attr.x
      let initalY = vec.attr.y
      switch (index) {
        case 8:
          attr['width'] += this.deltaX
          attr['height'] += this.deltaY
          break
        case 7:
          attr['height'] += this.deltaY
          break
        case 6:
          attr['x'] += this.deltaX
          attr['width'] -= this.deltaX
          attr['height'] += this.deltaY
          break
        case 5:
          attr['width'] += this.deltaX
          break
        case 4:
          attr['x'] += this.deltaX
          attr['y'] += this.deltaY
          break
        case 3:
          attr['x'] += this.deltaX
          attr['width'] -= this.deltaX
          break
        case 2:
          attr['y'] += this.deltaY
          attr['width'] += this.deltaX
          attr['height'] -= this.deltaY
          break
        case 1:
          attr['y'] += this.deltaY
          attr['height'] -= this.deltaY
          break
        case 0:
          attr['x'] += this.deltaX
          attr['y'] += this.deltaY
          attr['width'] -= this.deltaX
          attr['height'] -= this.deltaY
          break
      }
      attr['width'] = Math.max(attr['width'], minWidth)
      attr['height'] = Math.max(attr['height'], minHeight)

      if ([0, 1, 2, 3, 6].indexOf(index) > -1) {
        if (attr['width'] <= minWidth) {
          attr['x'] = initalX
        }
        if (attr['height'] <= minHeight) {
          attr['y'] = initalY
        }
      }
      Draw.setAttr(vector, attr)
      this.editRect()
    },
    polylineReSize () {
      let index = +this.index
      let vector = this.vector
      let vec = Draw.getAttr(vector, 1)
      let attr = Object.assign({}, vec.attr)
      let points = attr.points.split(' ')
      let point = points[index].split(',')
      point[0] = Number(point[0]) + this.deltaX
      point[1] = Number(point[1]) + this.deltaY
      if (index === 0) {
        points[points.length - 1] = point.join(',')
      }
      points[index] = point.join(',')
      attr.points = points.join(' ')
      Draw.setAttr(vector, attr)
      this.editPolyline()
    },
    comRect (points) {
      let newPoints = points.map((i) => {
        let p = i.split(',')
        return [Number(p[0]), Number(p[1])]
      })
      let pointX = newPoints.map((i) => {
        return i[0]
      })
      let pointY = newPoints.map((i) => {
        return i[1]
      })
      let minX = Math.min.apply(null, pointX)
      let maxX = Math.max.apply(null, pointX)
      let minY = Math.min.apply(null, pointY)
      let maxY = Math.max.apply(null, pointY)

      return {
        x: minX,
        y: minY,
        width: maxX - minX,
        height: maxY - minY
      }
    },
    isOut (e) {
      let editCanvas = this.$refs.edit_canvas
      let x = 0
      let y = 0
      let box = editCanvas.parentElement
      let el = editCanvas.parentElement
      x += el.offsetLeft
      y += el.offsetTop
      while (el) {
        el = el.offsetParent
        if (el && el.offsetLeft) {
          x += el.offsetLeft
          y += el.offsetTop
        }
      }
      return (e.clientX < x || e.clientX > x + box.offsetWidth || e.clientY < y || e.clientY > y + box.offsetHeight)
    },
    cancel () {
      let vector = this.vector
      this.drag = false
      Draw.setAttr(vector, this.deltaAttr)
      this.$emit('on-cancel', vector)
    },
    save () {
      this.drag = false
      let vector = this.vector
      this.$emit('on-save', vector)
    }
  }

}
</script>
<style lang="less" scoped>
.edit-svg {
  position: absolute;
  width: 100%;
  height: 100%;
}
.edit-svg-tools {
  position: absolute;
  top: 0;
  left: 0;
  opacity: 0.8;
}
</style>
