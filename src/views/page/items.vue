<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="8"><Icon type="ios-keypad"></Icon> {{type | title}} > {{groupName}} - {{taskName}}</Col>
                    <Col align="right">
                        <Select style="width:100px;text-align:left" @on-change="selectType" v-if="power!=3">
                            <Option value="0">{{ $t("menus.all") }}</Option>
                            <Option value="1">{{ $t("status.to_be_labelled") }}</Option>
                            <Option value="2">{{ $t("status.to_be_audited") }}</Option>
                            <Option value="3">{{ $t("status.audited") }}</Option>
                            <Option value="4">{{ $t("status.training") }}</Option>
                        </Select>
                        <Button :type="checkAll?'primary':'default'" @click="selectAll" :icon="checkAll?'android-checkbox-outline':'android-checkbox-outline-blank'">{{ $t("status.all_selected") }}</Button>
                        <Button icon="android-delete" v-if="power==1" :disabled="used()" @click="deleteImgs">{{ $t("general.delete") }}</Button>
                        <Button icon="checkmark" v-if="power==1" :disabled="used()" @click="changeType(2)">{{ $t("status.submit_for_review") }}</Button>
                        <Button icon="checkmark" v-if="power==2" :disabled="used()" @click="changeType(3)">{{ $t("status.accepted") }}</Button>
                        <Button icon="android-arrow-back" v-if="power==2" @click="backShow" :disabled="used()">{{ $t("general.reject") }}</Button>
                        <Button icon="checkmark" v-if="power==3" :disabled="used()" @click="showTrain">{{ $t("status.submit_for_training") }}</Button>
                        <Button icon="android-add" @click="addImage" v-if="power==1">{{ $t("general.add_image") }}</Button>
                    </Col>
                </Row>
            </p>
            <Row>
                <Col>
                    <ul class="vectorgraph">
                        <li v-for="(i,k) in data" :key="k" :class="{selected:i.selected}">
                            <div>
                                <div @click="select(i,k)" class="vector-img" :style="{backgroundImage:'url('+baseImgURL+'/'+i.fileSrc+')'}"></div>
                                <div class="item-button">
                                   <Row>
                                     <Col span="18">{{i.fileName}}</Col>
                                     <Col span="6" align="right"><Button @click="go(i)" size="small">{{ $t("general.review") }}</Button></Col>
                                  </Row>
                                </div>
                                <div class="ivu-poptip-popper item-audit-msg" x-placement="bottom-end" v-if="i.auditMsg && i.auditMsg.length>0 && i.status==='1'">
                                  <div>
                                    <div class="ivu-poptip-arrow"></div>
                                    <div class="item-audit-box">{{ $t("status.reason_for_rejected") }}：{{i.auditMsg}}</div>
                                  </div>
                                </div>
                                <div class="item-status" :status="i.status">
                                  <template v-if="i.auditMsg && i.auditMsg.length>0 && i.status==='1'">{{ $t("status.reject_to_be_labelled") }}</template>
                                  <template v-else>{{i.status|status}}</template>
                                </div>
                                <div class="item-checked" v-if="i.selected">
                                  <Icon type="android-done"></Icon>
                                </div>
                            </div>
                        </li>
                    </ul>
                </Col>
            </Row>
            <p style="padding-top:10px; text-align:right">
                <Page :total="total" :page-size="pageSize"
                @on-change="pageChange"
                @on-page-size-change="pageSizeChange"
                size="small" show-elevator show-sizer show-total></Page>
            </p>
        </Card>
        <Modal v-model="add" :closable='false' :mask-closable=false :width="600">
            <h3 slot="header" style="color:#2D8CF0">{{ $t("general.add_image") }}</h3>
            <Form ref="addForm" label-position="right" :label-width="80">
                <!-- <FormItem label="上传类型">
                    <Select>
                        <Option value="beijing">图片</Option>
                        <Option value="shanghai">压缩包</Option>
                    </Select>
                </FormItem> -->
                <Upload multiple :action="uploadURL" with-credentials name="pic" :data="formData">
                        <span>{{ $t("general.multi_file_upload") }}&nbsp;&nbsp;</span>
                        <Button type="ghost" icon="ios-cloud-upload-outline">{{ $t("general.upload_file") }}</Button>
                    </Upload>
            </Form>
            <div slot="footer">
                <!-- <Button type="text" @click="cancelAdd">取消</Button> -->
                <Button type="primary" :loading="save_loading" @click="saveAdd">{{ $t("general.finish") }}</Button>
            </div>
        </Modal>
        <Modal v-model="back">
            <h3 slot="header" style="color:#2D8CF0">{{ $t("general.reject") }}</h3>
            <Form ref="backForm" :model="backForm" label-position="right" :label-width="80" :rules="backFormRule">
                <FormItem label="退回原因" prop="auditMsg">
                   <Input v-model="backForm.auditMsg" type="textarea" :autosize="{minRows: 2,maxRows: 5}" placeholder="Enter something..."></Input>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelAdd">{{ $t("general.cancel") }}</Button>
                <Button type="primary" :loading="save_loading" @click="saveBack">{{ $t("general.submit") }}</Button>
            </div>
        </Modal>
        <Modal v-model="train" width="800">
          <h3 slot="header" style="color:#2D8CF0">{{ $t("general.set_training_paramter") }}</h3>
          <trainConfig :list="trainList" ref="trainConfig"></trainConfig>
          <div slot="footer">
            <Button type="text" @click="closeTrain">{{ $t("general.cancel") }}</Button>
            <Button type="primary" :loading="save_loading" @click="sendTrain">{{ $t("general.submit") }}</Button>
          </div>
        </Modal>
    </div>
</template>

<script>
import util from '../../libs/util'
import trainConfig from './train-config'

export default {
  name: 'items_index',
  components: {
    trainConfig
  },
  data () {
    return {
      add: false,
      save_loading: false,
      checkAll: false,
      power: 0,
      back: false,
      total: 0,
      pageSize: 10,
      page: 1,
      uploadURL: util.ajaxUrl + '/sign/imgFile/upload.do',
      baseImgURL: util.imgUrl,
      id: 0,
      formData: {
        idTaskInfo: ''
      },
      backForm: {
        auditMsg: ''
      },
      backFormRule: {
        auditMsg: [{ required: true, message: $t("status.rejected_message"), trigger: 'blur' }]
      },
      data: [],
      state: null,
      groupName: '',
      taskName: '',
      train: false,
      trainList: []
    }
  },
  filters: {
    status (v) {
      let r = ''
      switch (v) {
        case '1':r = $t("status.to_be_labelled"); break
        case '2':r = $t("status.to_be_audited"); break
        case '3':r = $t("status.audited"); break
        case '4':r = $t("status.training"); break
      }
      return r
    },
    title (v) {
      let r = ''
      switch (v) {
        case 'tagging':r = $t("tagging.data_labeling"); break
        case 'auditing':r = $t("auditing.data_review"); break
        case 'training':r = $t("training.model_training"); break
      }
      return r
    }
  },
  methods: {
    go (item) {
      this.$router.push({
        path: '/tools/' + this.type + '/' + item.idSignInfo,
        query: {
          page: this.page,
          pageSize: this.pageSize,
          idTaskInfo: this.id
        }
      })
    },
    addImage () {
      this.add = true
    },
    cancelAdd () {
      this.add = false
    },
    saveAdd () {
      this.add = false
      this.page = 1
      this.getData()
    },
    select (i, k) {
      this.data[k].selected = !this.data[k].selected
      this.checkAll = this.data.every(v => {
        return v.selected
      })
      this.$forceUpdate()
    },
    selectAll () {
      this.checkAll = !this.checkAll
      this.data.forEach(v => {
        v.selected = this.checkAll
      })
      this.$forceUpdate()
    },
    backShow () {
      this.back = true
    },
    saveBack () {
      this.$refs.backForm.validate((valid) => {
        if (valid) {
          this.changeType(1, this.backForm.auditMsg)
          this.backForm.auditMsg = ''
          this.back = false
        }
      })
    },
    getData () {
      let qs = require('qs')
      let url = ''
      if (this.type === 'tagging') {
        url = '/sign/queryUploadFileList.do'
      } else if (this.type === 'auditing') {
        url = '/sign/queryFileList.do'
      } else {
        url = '/sign/queryTrainFileList.do'
      }
      util.ajax.post(url, qs.stringify({
        pageIndex: this.page,
        pageSize: this.pageSize,
        idTaskInfo: this.id,
        state: this.state
      })).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          let data = res.data.data
          this.data = data && data.list
          this.total = data && data.fullListSize
        }
      })
    },
    pageChange (page) {
      this.page = page
      this.getData()
    },
    pageSizeChange (size) {
      this.pageSize = size
      this.page = 1
      this.getData()
    },
    used () {
      return !this.data.some(v => {
        return v.selected
      })
    },
    setPower () {
      switch (this.type) {
        case 'tagging':this.power = 1; break
        case 'auditing':this.power = 2; break
        case 'training':
          this.state = 3
          this.power = 3; break
      }
    },
    selectType (value) {
      this.state = value
      this.getData()
    },
    sendTrain () {
      let list = this.data.filter(v => {
        return v.selected
      })
      list = list.map(v => {
        return v.idSignInfo
      })
      this.trainList = list
      this.save_loading = true
      if (list.length > 0) {
        let config = this.$refs.trainConfig.config
        let type = this.$refs.trainConfig.type
        util.ajax.post('/train/startTrain.do', {
          config: config,
          signInfoIds: list,
          trainType: type
        }).then(res => {
          this.save_loading = false
          if (!res.data.status) {
            this.$Message.error(res.data.errormsg)
          } else {
            let data = res.data.data
            console.log(data)
            this.$router.push({
              name: 'trainlog',
              params: {
                id: data.idTrainInfo
              },
              query: {
                groupName: this.groupName,
                taskName: this.taskName,
                modelId: data.log_file_name
              }
            })
          }
        })
      }
    },
    showTrain () {
      this.train = true
    },
    closeTrain () {
      this.train = false
    },
    changeType (state, auditMsg) {
      let list = this.data.filter(v => {
        return v.selected
      })
      list = list.map(v => {
        return v.idSignInfo
      })
      util.ajax.post('/sign/updateStatus.do', {
        status: state,
        auditMsg: auditMsg || '',
        list: list
      }).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          this.$Message.success($t("status.success"))
          this.getData()
        }
      })
    },
    deleteImgs () {
      let list = this.data.filter(v => {
        return v.selected
      })
      list = list.map(v => {
        return v.idFileList
      })
      util.ajax.post('/sign/deleteFileList.do', list).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          this.getData()
        }
      })
    }
  },
  created () {
    this.id = this.$route.params.id
    this.type = this.$route.params.type
    this.groupName = this.$route.query.groupName
    this.taskName = this.$route.query.taskName
    this.setPower()
    this.formData.idTaskInfo = this.id
    this.getData()
  },
  mounted () {

  }
}
</script>
<style lang="less">
    ul.vectorgraph{
        overflow: hidden;
        list-style: none;
        &>li{
            width: 25%;
            float: left;
            position: relative;

            &>div{
                position: relative;
                margin: 30px;
                border: 3px solid transparent;
                border-radius: 10px;
                overflow: hidden;

                .vector-img{
                    width: 100%;
                    height:230px;
                    background-repeat: no-repeat;
                    background-size: cover;
                    background-position: center;
                }

                .item-button{
                  position: absolute;
                  bottom: 0;
                  left: 0;
                  right: 0;
                  background: linear-gradient(rgba(0,0,0,0), rgba(0,0,0,1));
                  color: #ffffff;
                  padding: 8px;
                }
                .item-status{
                  position: absolute;
                  right:0;
                  top:10px;
                  color: #FFFFFF;
                  padding: 5px;

                  &[status="1"]{
                    background-color: #FF8A00;
                  }
                  &[status="2"]{
                    background-color: #EF4949;
                  }
                  &[status="3"]{
                    background-color: #00B22D;
                  }
                  &[status="4"]{
                    background-color: #666666;
                  }
                }
                .item-audit-msg{
                  position: absolute;
                  top: 40px;
                  right: 5px;
                  max-width:90%;
                  display: none;
                }
                .item-audit-box{
                  background-color: #fff;
                  background-clip: padding-box;
                  border-radius: 4px;
                  box-shadow: 0 1px 6px rgba(0,0,0,.2);
                  padding: 8px;
                  word-wrap: break-word;
                  word-break: normal;
                }
                .item-checked{
                  position: absolute;
                  left: 0;
                  top: 0;
                  line-height: .9;
                  background-color: #ffad33;
                  &>i{
                    color: #FFFFFF;
                    font-size: 40px;
                    padding: 5px;
                    line-height: .8;
                  }
                  &>i::before{
                    text-shadow: 0 1px 6px rgba(0,0,0,.2);
                  }
                }

            }
            &:hover{
                &>div{
                    border: 3px solid #e9eaec;

                    .item-audit-msg{
                      display: block;
                    }
                }
            }
            &.selected{
                &>div{
                    border: 3px solid #ffad33;
                }
            }
        }

    }
</style>
