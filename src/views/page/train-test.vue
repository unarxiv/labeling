<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> {{groupName}} - {{taskName}} 模型测试</Col>
                    <Col span="4" align="right"></Col>
                </Row>
            </p>
            <div>
              <div style="text-align:center">
                <Form ref="addForm">
                  <Upload :action="uploadURL" with-credentials name="pic" :data="formData" :on-success="upSuccess" :on-error="upError" :before-upload="upBefore">
                    <Button type="ghost" icon="ios-cloud-upload-outline">上传</Button>
                  </Upload>
                </Form>
              </div>
              <div><Spin size="large" v-show="loading"></Spin></div>
              <div v-show="flag">
                <Row>
                    <Col span="12"><img src="" ref="preview" width="100%" height="100%"/></Col>
                    <Col span="12"><canvas id="output" ref="img_canvas_result" width="100%" height="100%"/></Col>
                </Row>
              </div>
            </div>
        </Card>
    </div>
</template>
<script>
import util from '../../libs/util'
import { detect } from '@/libs/service'
export default {
  components: {
  },
  data () {
    return {
      uploadURL: util.ajaxUrl + '',
      formData: {
        idTaskInfo: ''
      },
      loading: false,
      flag: false,
      result: []
    }
  },
  methods: {
    upBefore (file) {
      let self = this
      detect('b79cc2ba', file).then(function (res) {
        self.result = res.data
        self.labelTarget()
      })
      this.loading = true
      this.loadImg(this.getObjectURL(file))
    },
    labelTarget () {
      let c = document.getElementById('output')
      if (c == null) {
        return false
      }
      let ctx = c.getContext('2d')
      for (let index in this.result) {
        let xmin = this.result[index]['x_min']
        let xmax = this.result[index]['x_max']
        let ymin = this.result[index]['y_min']
        let ymax = this.result[index]['y_max']
        let width = xmax - xmin
        let height = ymax - ymin
        setTimeout(function () {
          ctx.strokeStyle = 'rgba(255, 0, 0, 5)'
          ctx.strokeRect(xmin, ymin, width, height)
        }, 200)
      }
    },
    loadImg (url) {
      let img = new Image()
      img.onload = () => {
        this.flag = true
        this.$refs.preview.src = url
        this.$nextTick(() => {
          let w = this.$refs.preview.offsetWidth
          let h = this.$refs.preview.offsetHeight
          this.$refs.img_canvas_result.width = w
          this.$refs.img_canvas_result.height = h
          let ctx = this.$refs.img_canvas_result.getContext('2d')
          ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, w, h)
        })
      }
      img.src = url
    },
    upSuccess (response, file, fileList) {
      setTimeout(() => {
        this.$Message.success('上传成功')
        this.loading = false
      }, 2000)
    },
    upError (e) {
      setTimeout(() => {
        this.$Message.error('上传失败')
        this.loading = false
      }, 2000)
    },
    getObjectURL (file) {
      var url = null
      if (window.createObjectURL) {
        url = window.createObjectURL(file)
      } else if (window.URL) {
        url = window.URL.createObjectURL(file)
      } else if (window.webkitURL) {
        url = window.webkitURL.createObjectURL(file)
      }
      return url
    }

  },
  created () {
    this.id = this.$route.params.id
    this.groupName = this.$route.query.groupName
    this.taskName = this.$route.query.taskName
  }
}
</script>
