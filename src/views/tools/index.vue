<template>
<div class="layout">
    <Layout :style="{minHeight: '100%'}">
      <div class="ivu-card ivu-card-bordered">
        <div class="ivu-card-head">
         <div class="ivu-col">
           <p style="overflow: visible;">
            <Row>
                <Col span="20"><Icon type="ios-keypad"></Icon> 标记{{fileName}}</Col>
                <Col span="4" align="right">
                  <Button type="primary" shape="circle" icon="android-add" @click="changeType(2)" v-if="listType==='tagging'">提交审批</Button>
                </Col>
            </Row>
            </p>
           </div>
        </div>
      </div>
        <Header>
          <div class="toolbar">
            <Tooltip content="返回" placement="bottom">
              <button @click="backPage" style="font-size:26px;color:rgba(29,193,207,.75);font-weight:100"><Icon type="backspace"></Icon></button>
            </Tooltip>
            <Tooltip :content="$t('tool.prev')" placement="bottom">
              <button class="pre" @click="goPage(-1)"></button>
            </Tooltip>
            <Tooltip :content="$t('tool.next')" placement="bottom">
              <button class="next" @click="goPage(1)"></button>
            </Tooltip>
            <Tooltip :content="$t('tool.zoom_out')" placement="bottom">
              <button class="enlarge" @click="setScale(1)"></button>
            </Tooltip>
            <Tooltip :content="$t('tool.zoom_in')" placement="bottom">
              <button class="narrow" @click="setScale(-1)"></button>
            </Tooltip>
            <Tooltip :content="$t('tool.auto_fit')" placement="bottom">
              <button class="appropriate" @click="setScale(0)"></button>
            </Tooltip>
            <Tooltip content="矩形标注" placement="bottom">
             <button class="rect" :class="{active:type===1}" @click="setType(1)"></button>
            </Tooltip>
            <Tooltip content="多边形标注" placement="bottom">
              <button class="polygon" :class="{active:type===2}" @click="setType(2)"></button>
            </Tooltip>
            <Tooltip content="自由标注" placement="bottom">
              <button class="line" :class="{active:type===3}" @click="setType(3)"></button>
            </Tooltip>
            <Tooltip content="线框颜色" placement="bottom">
              <ColorPicker v-model="color" recommend/>
            </Tooltip>
            <Tooltip content="撤销" placement="bottom">
              <button class="undo" :disabled="!(type===2 && this.points.length>0)"  @click="reply"></button>
            </Tooltip>
            <Tooltip content="重做" placement="bottom">
              <button class="redo" :disabled="!(type===2 && this.pointsBack.length>0)" @click="forward"></button>
            </Tooltip>
          </div>
        </Header>
        <Layout class="layout-content" ref="layoutcontent">
            <Content style="position:relative;overflow-x:auto" ref="content" :style="{background: '#f5f7f9'}">
              <section v-show="!loadingImage" class="l-section" ref="section"
                @mousemove="drawMove($event)"
                @mousedown="drawStart($event)"
                @mouseup="drawEnd($event)"
                @mouseout="drawOut($event)"
                @mousewheel="wheel($event)"
                @DOMMouseScroll="wheel($event)"
                >
                <canvas ref="img_canvas" width="100%" height="100%"/>
                <svg ref="draw_canvas" width="100%" height="100%"/>
                <svg ref="list_canvas" width="100%" height="100%"/>
              </section>
              <Spin size="large" fix v-show="loadingImage"></Spin>
            </Content>
            <Sider :style="{background: '#f5f7f9'}" >
              <div class="tag-box">
                <div class="tag-title">当前标注信息</div>
                <ol class="tag-ol">
                  <li class="tag-item" v-for="(v,i) in vectorgraph" :key="i" @click="selectNode(i)" :class="{active: hoverIndex===v.idLabelInfo}" @mouseover="tagItemOver($event,v)" @mouseout="tagItemOut($event,v)">
                      {{v.name}}
                  </li>
                </ol>
              </div>
              <div class="tag-box">
                <div class="tag-title">其他标注信息</div>
                <ol class="tag-ol">
                  <li class="tag-item" v-for="(v,i) in vectorgraphHis" :key="i" @click="setDefault(i)" :class="{active: v.checked}">
                      {{v.name}}
                  </li>
                </ol>
              </div>
            </Sider>
        </Layout>
    </Layout>
    <Modal
        v-model="attrInput"
        :styles="{top: '20px',left:'20px',position:'absolute'}"
        width="260"
        class-name="attr-box"
        :closable="false"
        @on-cancel="cancel"
        >
        <Form :model="formItem" :label-width="50" :rules="rules" ref="attrForm">
          <FormItem label="快捷">
          <Select v-model="quickList" placeholder="可以选择已标记过标签" @on-change="quickSelect">
            <Option value="-1" disabled>可以选择已标记过标签</Option>
            <Option v-for="(v,i) in vectorgraphHis" :value="i" :key="i">{{ v.name }}</Option>
          </Select>
          </FormItem>
           <FormItem label="快选" v-if="vectorgraphHis.length != 0">
              <RadioGroup v-model="quickList">
                  <Radio :label="index" v-for = "(item, index) in vectorgraphHis.slice(0,3)" :key="index">
                      <span>{{item.name}}</span>
                  </Radio>
              </RadioGroup>
            </FormItem>
          <FormItem label="名称" prop="name">
              <Input v-model="formItem.name" placeholder="Enter object name" />
          </FormItem>
          <!-- <FormItem label="闭塞">
              <RadioGroup v-model="formItem.radio">
                  <Radio label="yes">是</Radio>
                  <Radio label="no">否</Radio>
              </RadioGroup>
          </FormItem> -->
          <FormItem label="描述" prop="desc">
              <Input v-model="formItem.desc" type="textarea" :autosize="{minRows: 3,maxRows: 3}" placeholder="Enter attributes..."></Input>
          </FormItem>
          <!-- <FormItem label="边框">
              <ColorPicker v-model="formItem.color" />
          </FormItem> -->
        </Form>
        <div slot="footer">
            <Button type="text" size="small" @click="cancel">取消</Button>
            <Button type="warning" size="small" @click="deleteNode">删除</Button>
            <Button type="primary" size="small" @click="confirm">确定</Button>
        </div>
    </Modal>
</div>
</template>

<script>
import Draw from './draw'
import util from '../../libs/util'
export default {
  name: 'tools',
  data () {
    return {
      isCollapsed: true,
      color: '#FB4F41',
      draw: false,
      startDot: null,
      drawEl: null,
      startOffset: {x: 0, y: 0},
      type: 1,
      points: [],
      vectorgraph: [

      ],
      vectorgraphHis: [
        {
          name: '人',
          desc: '人物介绍'
        },
        {
          name: '狗狗',
          desc: '狗狗介绍'
        }
      ],
      start: true,
      end: true,
      sectionWidth: 0,
      sectionHeight: 0,
      availHeight: 0,
      availWidth: 0,
      scale: 1,
      attrInput: false,
      formItem: {
        name: '',
        radio: '',
        desc: '',
        color: ''
      },
      imgUrls: [
        // require('./image/img1.jpg'),
        // require('./image/img2.jpg')
      ],
      rules: {
        name: [
          { required: true, message: '属性名称不能为空', trigger: 'blur' }
        ],
        desc: [
          { required: true, message: '描述不能为空', trigger: 'blur' }
        ]
      },
      page: 0,
      pageSize: 10,
      idTaskInfo: 0,
      pointsBack: [],
      id: 0,
      fileSrc: '',
      idLabelInfo: 0,
      fileName: '',
      hoverIndex: '',
      loadingImage: false,
      remoteList: [],
      listType: '',
      dataList: [],
      quickList: '',
      cacheImgs: {},
      preImg: null,
      nextImg: null
    }
  },
  methods: {
    backPage () {
      this.$router.go(-1)
    },
    goHome () {
      this.$router.push({
        name: 'home_index'
      })
    },
    setType (t) {
      this.type = t
      this.deleteNode()
      Draw.removeNode(this.startDot)
      this.startDot = null

      this.points = []
      this.pointsBack = []
      this.end = false
      this.draw = false
    },
    drawStart (e) {
      if (!this.start) return
      this.draw = true
      this.end = false
      this.startDot = this.startDot || Draw.vector('circle')

      this.startOffset = {
        x: e.offsetX,
        y: e.offsetY
      }
      switch (this.type) {
        case 1 :this.drawEl = Draw.vector('rect')
          this.drawPoint(this.startDot, e)
          break
        case 2 :this.drawEl = this.drawEl || Draw.vector('polyline')
          this.draw = false
          if (this.points.length === 0) {
            this.drawPoint(this.startDot, e)
            // this.points.push({
            //     x: e.offsetX,
            //     y: e.offsetY
            // });
          }
          break
        case 3 :this.drawEl = this.drawEl || Draw.vector('polyline')
          if (this.points.length === 0) {
            this.drawPoint(this.startDot, e)
          }
          this.points.push({
            x: e.offsetX,
            y: e.offsetY
          })
          break
      }

      this.$refs.draw_canvas.appendChild(this.drawEl)
      this.$refs.draw_canvas.appendChild(this.startDot)
    },
    drawMove (e) {
      if (!this.draw && this.type !== 2) return
      if (this.type === 1) {
        this.drawRect(this.drawEl, e)
      } else if (this.type === 2) {
        if (this.points.length > 0) {
          let points = this.points.slice()
          points.push({
            x: e.offsetX,
            y: e.offsetY
          })
          this.drawPoly(this.drawEl, points)
        }
      } else if (this.type === 3) {
        if (this.points.length > 1 && Math.abs(this.points[0].x - e.offsetX) <= 4 && Math.abs(this.points[0].y - e.offsetY) <= 4) {
          this.points.push({
            x: this.points[0].x,
            y: this.points[0].y
          })
          this.end = true
        } else {
          this.points.push({
            x: e.offsetX,
            y: e.offsetY
          })
        }
        if (this.points.length > 0) {
          this.drawPoly(this.drawEl)
        }
      }
    },
    drawEnd (e) {
      if (!this.start) return
      switch (this.type) {
        case 1:
          this.end = true
          break
        case 2:
          if (this.points.length === 0) {
            if (this.startDot) {
              this.drawPoint(this.startDot, e)
            }
          }
          if (this.points.length > 1 && Math.abs(this.points[0].x - e.offsetX) <= 6 && Math.abs(this.points[0].y - e.offsetY) <= 6) {
            this.points.push({
              x: this.points[0].x,
              y: this.points[0].y
            })
            this.end = true
          } else {
            this.points.push({
              x: e.offsetX,
              y: e.offsetY
            })
          }
          if (this.points.length > 0) {
            this.drawPoly(this.drawEl)
          }
          if (this.isReply === true) {
            this.pointsBack = []
            this.isReply = false
          }
          break
        case 3:
          this.points.push({
            x: this.startOffset.x,
            y: this.startOffset.y
          })
          if (this.points.length > 0) {
            this.drawPoly(this.drawEl)
          }
          this.end = true
          break
      }
      if (this.end) {
        this.saveCanvas()
      }
    },
    drawOut (e) {
    },
    drawPoint (el, e) {
      Draw.setAttr(el, {
        'cx': e.offsetX,
        'cy': e.offsetY,
        'r': 6,
        'stroke': 'black',
        'stroke-width': 2,
        'fill': '#2db7f5'
      })
    },
    drawRect (el, e) {
      Draw.setAttr(el, {
        'x': Math.min(this.startOffset.x, e.offsetX),
        'y': Math.min(this.startOffset.y, e.offsetY),
        'width': Math.abs(this.startOffset.x - e.offsetX),
        'height': Math.abs(this.startOffset.y - e.offsetY),
        'stroke': this.color,
        'stroke-width': 4 * this.scale,
        'fill': 'none',
        'stroke-linecap': 'round'
        // 'style': 'fill: ' + this.color + ';stroke:' + this.color + ';stroke-width:4;fill-opacity:0;stroke-opacity:0.9'
      })
    },
    drawPoly (el, points) {
      points = points || this.points
      if (points.length > 0) {
        Draw.setAttr(el, {
          'points': Draw.pointsToString(points),
          'stroke': this.color,
          'stroke-width': 4 * this.scale,
          'fill': 'none',
          'stroke-linecap': 'round'
        })
      } else {
        this.startDot && Draw.removeNode(this.startDot)
        this.startDot = null
        this.drawEl && Draw.removeNode(this.drawEl)
        this.drawEl = null
        this.pointsBack = []
      }
    },
    saveCanvas () {
      let vector = this.drawEl
      if (vector && vector.nodeName === 'rect') {
        if (!vector.getAttribute('width') ||
                !vector.getAttribute('height')
        ) {
          Draw.removeNode(this.startDot)
          this.startDot = null
          Draw.removeNode(this.drawEl)
          this.drawEl = null
          this.points = []
          this.draw = false
          return
        }
      }
      this.addVectorEvent(this.drawEl)
      this.$refs.list_canvas.appendChild(this.drawEl)
      Draw.removeNode(this.startDot)
      this.startDot = null

      this.points = []
      this.pointsBack = []
      this.draw = false
      if (this.autoSave()) {
        this.attrInput = true
        this.$nextTick(() => {
          this.vectorClick(this.drawEl)
        })
      }
    },
    initSize () {
      this.$refs.section.style.width = this.availWidth + 'px'
      this.$refs.section.style.height = this.availHeight + 'px'
      this.$refs.img_canvas.width = this.availWidth
      this.$refs.img_canvas.height = this.availHeight
      this.$refs.draw_canvas.setAttribute('width', this.availWidth)
      this.$refs.draw_canvas.setAttribute('height', this.availHeight)
      this.$refs.list_canvas.setAttribute('width', this.availWidth)
      this.$refs.list_canvas.setAttribute('height', this.availHeight)
    },
    loadImage () {
      let img = new Image()
      this.loadingImage = true
      img.onload = () => {
        this.loadingImage = false
        this.sectionWidth = this.$refs.content.$el.offsetWidth
        this.sectionHeight = this.$refs.content.$el.offsetHeight
        let size = Draw.fitSize(img.width, img.height, this.sectionWidth, this.sectionHeight)
        this.availWidth = size.w
        this.availHeight = size.h
        this.scale = size.w / img.width

        this.initSize()
        let ctx = this.$refs.img_canvas.getContext('2d')

        ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, size.w, size.h)
        this.addVector()
      }
      // img.src = this.imgUrls[this.page];
      if (this.cacheImgs[this.fileSrc]) {
        img.src = this.cacheImgs[this.fileSrc].src
      } else {
        img.src = this.fileSrc
      }
    },
    resize () {
      this.loadImage()
    },
    addVector () {
      let svg = this.$refs.list_canvas
      // svg.innerHTML = ''
      while (svg.childNodes.length > 0) {
        svg.removeChild(svg.firstChild)
      }
      this.vectorgraph.forEach(v => {
        let vector = Draw.vector(v.type)
        v.el = vector
        Draw.setAttr(vector, Draw.fitAttr(v.attr, v.type, this.scale))
        this.addVectorEvent(vector)
        svg.appendChild(vector)
      })
    },
    addVectorEvent (el) {
      el.addEventListener('mouseover', (e) => {
        e.preventDefault()
        // e.target.style = 'fill:red;stroke-width:' + this.scale * 6 + ';fill-opacity:0.3;stroke-opacity:0.9'
        e.target.setAttribute('style', 'fill:red;stroke-width:' + this.scale * 6 + ';fill-opacity:0.3;stroke-opacity:0.9')
        this.start = false
        let target = this.vectorgraph.filter((v) => {
          return v.el === e.target
        })
        this.hoverIndex = target.length > 0 ? target[0].idLabelInfo : ''
      }, false)
      el.addEventListener('mouseout', (e) => {
        e.preventDefault()
        // e.target.style = ''
        e.target.setAttribute('style', '')
        this.start = true
        this.hoverIndex = ''
      }, false)
      el.addEventListener('click', (e) => {
        e.preventDefault()
        if (this.end === false) {

        } else {
          this.attrInput = true
          let vector = e.target
          this.$nextTick(() => {
            this.vectorClick(vector)
          })
        }
      }, false)
    },
    setScale (t) {
      let scaleStr = this.$refs.section.style.transform.replace(/scale\(([0-9.]+)\)/g, '$1')
      let scale = scaleStr.length === 0 ? 1 : Number(scaleStr)
      switch (t) {
        case 0:scale = 1; break
        case 1:scale += 0.1; break
        case -1:scale -= 0.1; break
      }
      this.$refs.section.style.transform = 'scale(' + scale + ')'
    },
    vectorClick (vector) {
      this.drawEl = vector
      this.quickList = -1
      let f = this.vectorgraph.filter(v => {
        return v.el === this.drawEl
      })
      if (f.length > 0) {
        this.formItem.name = f[0].name
        this.formItem.desc = f[0].desc
      } else {
        let checks = this.vectorgraphHis.filter((v, k) => {
          return v.checked
        })
        if (checks.length > 0) {
          this.formItem.name = checks[0].name
          this.formItem.desc = checks[0].desc
        }
      }
      let modal = document.querySelector('.attr-box .ivu-modal')
      let points = Draw.getFirstPoint(vector)
      let xy = Draw.getOffset(this.$refs.section)
      let maxHeight = document.documentElement.offsetHeight
      if (points.y + modal.offsetHeight + 8 + xy.y > maxHeight) {
        points.y = points.y - modal.offsetHeight - 10 + xy.y
        points.x = points.x - 26 > 0 ? points.x - 26 : 0
        setTimeout(() => {
          modal.classList.remove('top-arrow')
          modal.classList.add('bottom-arrow')
        }, 100)
      } else {
        points.y = points.y + 10 + xy.y
        points.x = points.x - 26 > 0 ? points.x - 26 : 0
        setTimeout(() => {
          modal.classList.remove('bottom-arrow')
          modal.classList.add('top-arrow')
        }, 100)
      }
      modal.style.left = (points.x + xy.x) + 'px'
      modal.style.top = points.y + 'px'
    },
    confirm () {
      this.$refs.attrForm.validate((valid) => {
        if (valid) {
          this.attrInput = false
          if (this.drawEl) {
            let attr = Draw.getAttr(this.drawEl, this.scale)
            attr.name = this.formItem.name
            attr.desc = this.formItem.desc
            attr.tool = this.type
            attr.el = this.drawEl
            let index = 0
            let f = this.vectorgraph.filter((v, i) => {
              if (v.el === this.drawEl) {
                index = i
                return true
              }
            })
            if (f.length === 0) {
              this.vectorgraph.push(attr)
              this.saveTag(attr)
            } else {
              attr.idLabelInfo = this.vectorgraph[index].idLabelInfo
              this.vectorgraph[index] = attr
              this.updateTag(attr)
            }

            this.drawEl = null
          }
        }
      })
    },
    deleteNode () {
      this.attrInput = false
      if (this.drawEl) {
        let index = 0
        let f = this.vectorgraph.filter((v, i) => {
          if (v.el === this.drawEl) {
            index = i
            return true
          }
        })
        if (f.length > 0) {
          let attr = this.vectorgraph.splice(index, 1)
          this.deleteTag(attr[0])
        }
        Draw.removeNode(this.drawEl)
        this.drawEl = null
      }
      this.$refs.attrForm.resetFields()
    },
    cancel () {
      this.attrInput = false
      this.$refs.attrForm.resetFields()
      if (this.drawEl) {
        let f = this.vectorgraph.filter(v => {
          return v.el === this.drawEl
        })
        if (f.length === 0) {
          Draw.removeNode(this.drawEl)
        }
        this.drawEl = null
      }
    },
    selectNode (i) {
      let item = this.vectorgraph[i]
      this.attrInput = true
      this.color = item.attr.stroke
      this.type = item.tool
      this.$nextTick(() => {
        this.vectorClick(item.el)
      })
    },
    getImage (p) {
      if (p > 0) {
        this.page = 1
      } else {
        this.page = 0
      }
      // this.vectorgraph = TestData[this.page];
      this.loadImage()
    },
    reply () {
      if (this.type === 2) {
        let item = this.points.pop()
        item && this.pointsBack.push(item)
        this.drawPoly(this.drawEl)
        this.isReply = true
      }
    },
    forward () {
      if (this.type === 2) {
        let item = this.pointsBack.pop()
        item && this.points.push(item)
        this.drawPoly(this.drawEl)
      }
    },
    getData () {
      util.ajax.post('/sign/querySignInfo.do', 'idSignInfo=' + this.id).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          let data = res.data.data
          this.fileName = data.fileName
          this.fileSrc = util.imgUrl + data.fileSrc
          this.vectorgraph = []
          this.vectorgraph = this.formatData(data.list)
          this.loadImage()
        }
      })
    },
    saveTag (attr) {
      util.ajax.post('/sign/addSignInfo.do', {
        signInfoId: this.id,
        labelName: attr.name,
        labelInfo: JSON.stringify(attr),
        labelRemark: attr.desc,
        idTaskInfo: this.idTaskInfo
      }).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          this.$Message.success('已保存')
          this.vectorgraph[this.vectorgraph.length - 1].idLabelInfo = res.data.data.idLabelInfo
          this.addHisData(this.vectorgraph[this.vectorgraph.length - 1])
        }
      })
    },
    updateTag (attr) {
      util.ajax.post('/sign/updateSignInfo.do', {
        idLabelInfo: attr.idLabelInfo,
        labelName: attr.name,
        labelInfo: JSON.stringify(attr),
        labelRemark: attr.desc
      }).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          this.$Message.success('已保存')
          this.addHisData(attr)
        }
      })
    },
    deleteTag (attr) {
      util.ajax.post('/sign/deleteSignInfo.do', 'idLabelInfo=' + attr.idLabelInfo).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          this.$Message.success('已删除')
        }
      })
    },
    deleteHisTag (idTaskInfo, labelName, labelRemark) {
      var deletePostData = 'id_task_info=' + idTaskInfo + '&label_name=' + labelName + '&label_desc=' + labelRemark
      util.ajax.post('/sign/deleteHisSignInfoDto.do', deletePostData).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          this.$Message.success('已删除')
        }
      })
    },
    formatData (list) {
      let re = []
      list.forEach((v) => {
        let labelInfo = {}
        labelInfo = JSON.parse(v.labelInfo)
        labelInfo.idLabelInfo = v.idLabelInfo
        re.push(labelInfo)
      })
      return re
    },
    tagItemOver (e, v) {
      this.hoverIndex = v.idLabelInfo
      // v.el.style = 'fill:red;stroke-width:' + this.scale * 6 + ';fill-opacity:0.3;stroke-opacity:0.9'
      v.el.setAttribute('style', 'fill:red;stroke-width:' + this.scale * 6 + ';fill-opacity:0.3;stroke-opacity:0.9')
    },
    tagItemOut (e, v) {
      // v.el.style = ''
      v.el.setAttribute('style', '')
      this.hoverIndex = ''
    },
    changeType (state, auditMsg) {
      if (this.vectorgraph.length === 0) {
        this.$Message.error('您还未做任何标记！')
        return
      }
      let list = []
      list.push(this.id)
      util.ajax.post('/sign/updateState.do', {
        state: state,
        auditMsg: auditMsg || '',
        list: list
      }).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          this.$Message.success('操作成功！')
          this.getData()
        }
      })
    },
    remoteMethod (query) {
      let re = []
      if (query && query.length > 0) {
        re = this.vectorgraph.filter((i) => {
          return i.name.indexOf(query) > -1
        })
      }
      this.remoteList = re
    },
    remoteChange (v) {
      let re = []
      if (v) {
        re = this.vectorgraph.filter((i) => {
          return i.idLabelInfo === v
        })
        if (re.length > 0) {
          this.formItem.desc = re[0].desc
          this.remoteList = []
        }
      }
    },
    setDefault (i) {
      let _item = this.vectorgraphHis[i]
      this.vectorgraphHis.forEach((v, k) => {
        if (i !== k) {
          v.checked = false
        }
      })
      console.log(this.vectorgraphHis[i])
      _item.checked = !_item.checked
      if (_item.checked) {
        this.$Modal.confirm({
          closable: true,
          title: '提示',
          content: '<p style="font-size:14px">1、选中该项，接下来的标注默认都用该属性,不会再弹框确认,再次点击可以取消</p><p style="font-size:14px">2、点击删除按钮，可删除该标签</p>',
          okText: '确认',
          cancelText: '删除',
          onCancel: () => {
            this.deleteHisTag(this.idTaskInfo, this.vectorgraphHis[i].labelName, this.vectorgraphHis[i].labelRemark)
            this.vectorgraphHis.splice(i, 1)
            Draw.removeNode(this.drawEl)
            this.drawEl = null
            this.$refs.attrForm.resetFields()
          }
        })
      }
      this.$forceUpdate()
    },
    getDataList (load) {
      let qs = require('qs')
      let url = ''
      if (this.listType === 'tagging') {
        url = '/sign/queryUploadFileList.do'
      } else if (this.listType === 'auditing') {
        url = '/sign/queryFileList.do'
      } else {
        url = '/sign/queryTrainFileList.do'
      }
      util.ajax.post(url, qs.stringify({
        pageIndex: this.page,
        pageSize: this.pageSize,
        idTaskInfo: this.idTaskInfo,
        state: this.state
      })).then(res => {
        if (!res.data.status) {
          if (load === 'pre') {
            this.$Message.warning('已经到了第一张')
            this.page = this.page + (load === 'pre' ? 1 : -1)
          } else {
            this.$Message.error(res.data.errormsg)
          }
        } else {
          let data = res.data.data
          if (load) {
            if (data.list.length > 0) {
              this.id = data.list[0].idSignInfo
              this.dataList = data.list
              this.getData()
            } else {
              this.$Message.warning('已经是最后一张了')
              this.page = this.page + (load === 'pre' ? 1 : -1)
            }
          } else {
            this.dataList = data.list
          }
        }
      })
    },
    getUpData () {
      let qs = require('qs')
      let url = '/sign/queryFilesForNext.do'
      util.ajax.get(url + '?' + qs.stringify({
        idSignInfo: this.id,
        loadType: 'up',
        loadSize: 1
      })).then(res => {
        this.preImg = null
        if (res.data.status) {
          let data = res.data.data
          data.forEach((i) => {
            let img = new Image()
            img.src = util.imgUrl + i.fileSrc
            this.cacheImgs[img.src] = img
          })
          if (data.length > 0) {
            this.preImg = data[0]
          }
        }
      })
    },
    getDownData () {
      let qs = require('qs')
      let url = '/sign/queryFilesForNext.do'
      util.ajax.get(url + '?' + qs.stringify({
        idSignInfo: this.id,
        loadType: 'down',
        loadSize: 1
      })).then(res => {
        this.nextImg = null
        if (res.data.status) {
          let data = res.data.data
          data.forEach((i) => {
            let img = new Image()
            img.src = util.imgUrl + i.fileSrc
            this.cacheImgs[img.src] = img
          })
          if (data.length > 0) {
            this.nextImg = data[0]
          }
        }
      })
    },
    goPage (t) {
      if (t < 0) {
        if (this.preImg === null) {
          this.$Message.warning('已经到了第一张')
        } else {
          this.id = this.preImg.idSignInfo
          this.getData()
          this.$router.replace({
            path: '/tools/' + this.listType + '/' + this.id,
            query: {
              idTaskInfo: this.idTaskInfo
            }
          })
        }
      } else if (t > 0) {
        if (this.nextImg === null) {
          this.$Message.warning('已经到了最后一张')
        } else {
          this.id = this.nextImg.idSignInfo
          this.getData()
          this.$router.replace({
            path: '/tools/' + this.listType + '/' + this.id,
            query: {
              idTaskInfo: this.idTaskInfo
            }
          })
        }
      }
    },
    goPage2 (t) {
      this.setScale(0)
      let inx = 0
      let id = this.id
      this.dataList.forEach((v, k) => {
        if (v.idSignInfo === id) {
          inx = k
        }
      })
      if (t > 0) {
        inx = inx + 1
      } else {
        inx = inx - 1
      }
      if (inx < 0) {
        this.page = this.page - 1
        this.getDataList('pre')
      } else if (inx >= this.dataList.length) {
        this.page = this.page + 1
        this.getDataList('next')
      } else {
        this.id = this.dataList[inx].idSignInfo
        this.getData()
      }
    },
    getTaged () {
      util.ajax.get('/sign/queryHisSignLabel.do?idTaskInfo=' + this.idTaskInfo).then(res => {
        let resp = res.data
        if (resp.status) {
          resp.data.map((v) => {
            v.name = v.labelName
            v.desc = v.labelRemark
          })
          this.vectorgraphHis = resp.data
        }
      })
    },
    addHisData (info) {
      let f = this.vectorgraphHis.filter((v) => {
        return v.name === info.name && v.desc === info.desc
      })
      if (f.length === 0) {
        this.vectorgraphHis.push({
          name: info.name,
          desc: info.desc
        })
      }
    },
    wheel (e) {
      e.preventDefault()
      let direction = 0
      if (e.wheelDelta) {
        direction = e.wheelDelta > 0 ? 1 : -1
      } else if (e.detail) {
        direction = e.detail < 0 ? 1 : -1
      }
      if (direction) {
        this.setScale(direction)
      }
    },
    keydown (e) {
      if (e.type === 'keydown' && e.keyCode === 17) {
        this.keydownctrl = true
      }
    },
    keyup (e) {
      if (e.type === 'keyup') {
        if (e.keyCode === 37) {
          this.goPage(-1)
        } else if (e.keyCode === 39) {
          this.goPage(1)
        }
        if (this.keydownctrl === true && e.keyCode === 90) {
          this.reply()
        }
        if (this.keydownctrl === true && e.keyCode === 89) {
          this.forward()
        }
        if (e.keyCode === 17) {
          this.keydownctrl = null
        }
      }
    },
    quickSelect (i) {
      if (Number(i) === -1 || typeof i === 'undefined') {
        return
      }
      let _item = this.vectorgraphHis[i]
      this.formItem.name = _item.name
      this.formItem.desc = _item.desc
    },
    autoSave () {
      let checks = this.vectorgraphHis.filter((v, k) => {
        return v.checked
      })
      if (checks.length > 0) {
        this.formItem.name = checks[0].name
        this.formItem.desc = checks[0].desc
        this.confirm()
        return false
      } else {
        return true
      }
    }
  },
  created () {
    this.id = this.$route.params.id
    this.listType = this.$route.params.type
    this.page = Number(this.$route.query.page)
    this.pageSize = this.$route.query.pageSize
    this.idTaskInfo = this.$route.query.idTaskInfo
    this.getData()
    // this.getDataList()
    this.getTaged()
    window.addEventListener('resize', this.resize, false)
    document.addEventListener('resize', this.resize, false)
    document.addEventListener('keydown', this.keydown, false)
    document.addEventListener('keyup', this.keyup, false)
  },
  mounted () {
    this.$refs.layoutcontent.$el.style.height = (document.body.offsetHeight - this.$refs.content.$el.offsetTop - 94 - 30) + 'px'
    this.loadImage()
  },
  watch: {
    id () {
      this.getUpData()
      this.getDownData()
    },
    quickList: function () {
      this.quickSelect(this.quickList)
    }
  },
  destroyed () {
    window.removeEventListener('resize', this.resize, false)
    document.removeEventListener('resize', this.resize, false)
    document.removeEventListener('keydown', this.keydown, false)
    document.removeEventListener('keyup', this.keyup, false)
  }
}
</script>
<style lang="less" scoped>
    @import './tools.less';
</style>
<style lang="less">
  .attr-box{
      .ivu-modal{
          &.top-arrow:before{
              content: '';
              top:-8px;
              left: 18px;
              position: absolute;
              height: 15px;
              width: 15px;
              background: #fff;
              transform: rotate(45deg);
          }
          &.bottom-arrow:before{
              content: '';
              bottom:-8px;
              left: 18px;
              position: absolute;
              height: 15px;
              width: 15px;
              background: #fff;
              transform: rotate(45deg);
          }

      }

      textarea.ivu-input{
          font-size:12px;
      }
  }
  .ivu-color-picker-picker-colors{
      line-height:1em;
  }
  .toolbar{
    background-color: #313343;
    .ivu-tooltip-rel{
        vertical-align: middle;
        height: 50px;
        line-height: 50px;
        background-color: #313343;
        .ivu-input{
          border: 1px solid #313343;
          background-color: transparent;
        }
    }
  }
</style>
