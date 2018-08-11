<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> {{groupName}} - {{taskName}} {{ $t("training.model_testing") }}</Col>
                    <Col span="4" align="right"></Col>
                </Row>
            </p>
            <div>
              <div style="text-align:center">
                <Form ref="addForm">
                  <Upload :action="uploadURL" with-credentials name="pic" :data="formData" :on-success="upSuccess" :on-error="upError" :before-upload="upBefore">
                    <Button type="ghost" icon="ios-cloud-upload-outline">{{ $t("general.upload_image") }}</Button>
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
          <div>
            <h4>Request Address</h4>
            <pre>{{ inferenceEndpoint }}</pre>
            <p><a href="https://docs.cvtron.xyz/zh/guide/serve-reference/">{{ $t("menus.how_to_use") }}</a></p>
          </div>
        </Card>
    </div>
</template>
<script>
import util from '../../libs/util'
import { detect, getInferenceEndpoint } from '@/libs/service'
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
      result: [],
      inferenceEndpoint: ''
    }
  },
  methods: {
    upBefore (file) {
      let self = this
      detect(self.$route.query.modelId, file).then(function (res) {
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
      let self = this
      setTimeout(() => {
        this.$Message.success(self.$i18n.t('status.upload_success'))
        this.loading = false
      }, 2000)
    },
    upError (e) {
      let self = this
      setTimeout(() => {
        this.$Message.error(self.$i18n.t('status.upload_fail'))
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
    this.inferenceEndpoint = getInferenceEndpoint(this.$route.query.modelId)
  }
}
</script>
