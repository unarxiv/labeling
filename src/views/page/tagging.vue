<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> {{$t('router.label')}}</Col>
                    <Col span="4" align="right">
                    <Button type="ghost" shape="circle" icon="android-add" @click="showAdd">{{$t('tagging.create_batch')}}</Button>
                    </Col>
                </Row>
            </p>
            <Row>
                <Table :columns="columns" :data="data"></Table>
            </Row>
            <p style="padding-top:10px; text-align:right">
                <Page :total="total" :page-size="pageSize"
                @on-change="pageChange"
                @on-page-size-change="pageSizeChange"
                size="small" show-elevator show-sizer show-total></Page>
            </p>
        </Card>
        <Modal v-model="add" :closable='false' :mask-closable=false :width="400">
            <h3 slot="header" style="color:#2D8CF0">{{addText}}</h3>
            <Form ref="addForm" :model="addForm" label-position="right" :rules="formValidate" :label-width="80">
                <FormItem :label="$t('tagging.batch_name')" prop="taskName">
                    <Input v-model="addForm.taskName" :placeholder="$t('tagging.input_batch_name')"/>
                </FormItem>
                <FormItem :label="$t('tagging.belongs_to')"  prop="idGroup">
                    <Select v-model="addForm.idGroup" :placeholder="$t('tagging.choose_group')" @on-change="groupChange">
                        <Option v-for="(item,key) in groups" :value="item.idGroup+''" :key="key" :label="item.name">{{item.name}}</Option>
                        <Option :value="0" key="" label="" style="text-align:center">--- {{$t('auditing.add_group')}} ---</Option>
                    </Select>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelAdd">{{$t('general.cancel')}}</Button>
                <Button type="primary" :loading="save_loading" @click="saveAdd">{{$t('general.submit')}}</Button>
            </div>
        </Modal>
    </div>
</template>
<script>
import expandRow from './data-detail.vue'
import util from '../../libs/util'
export default {
  components: { expandRow },
  data () {
    return {
      columns: [
        {
          title: this.$i18n.t('table.no'),
          key: 'idTaskInfo'
        },
        {
          title: this.$i18n.t('table.group'),
          key: 'groupName'
        },
        {
          title: this.$i18n.t('table.batch'),
          key: 'taskName'
        },
        {
          title: this.$i18n.t('table.audited'),
          key: 'auditNum'
        },
        {
          title: this.$i18n.t('table.need_audit'),
          key: 'unAuditNum'
        },
        {
          title: this.$i18n.t('table.need_label'),
          key: 'unSignNum'
        },
        {
          title: this.$i18n.t('table.total'),
          key: 'allNum'
        },
        {
          title: this.$i18n.t('table.createdAt'),
          key: 'createdDate',
          width: 200
        },
        {
          title: this.$i18n.t('table.operation'),
          key: 'action',
          width: 120,
          render: (h, params) => {
            const row = params.row
            let buts = []
            buts.push(h('Button', {
              props: {
                size: 'small'
              },
              on: {
                click: () => {
                  this.$router.push({
                    path: '/item/tagging/' + row.idTaskInfo,
                    query: {
                      groupName: row.groupName,
                      taskName: row.taskName
                    }
                  })
                }
              }
            }, this.$i18n.t('table.view')))
            buts.push(h('Button', {
              props: {
                size: 'small'
              },
              on: {
                click: () => {
                  window.open('/sign_web/sign/downSign.do?idTaskInfo=' + row.idTaskInfo)
                }
              }
            }, this.$i18n.t('table.download_json')))
            return h('div', buts)
          }
        }
      ],
      data: [
      ],
      add: false,
      addText: this.$i18n.t('tagging.create_batch'),
      formValidate: {
        taskName: [
          { required: true, message: this.$i18n.t('tagging.input_batch_name'), trigger: 'blur' }
        ],
        idGroup: [
          { required: true, message: this.$i18n.t('tagging.choose_group'), trigger: 'change' }
        ]
      },
      save_loading: false,
      groups: [],
      addForm: {
        taskName: '',
        idGroup: ''
      },
      total: 0,
      pageSize: 10,
      page: 1

    }
  },
  methods: {
    showAdd () {
      this.add = true
      this.addText = this.$i18n.t('tagging.create_batch')
      this.addForm = {
        taskName: '',
        idGroup: ''
      }
    },
    showEdit () {
      this.add = true
      this.addText = this.$i18n.t('tagging.edit_batch')
    },
    saveAdd () {
      this.$refs.addForm.validate((valid) => {
        if (valid) {
          this.save_loading = true
          util.ajax.post(this.addText === this.$i18n.t('tagging.edit_batch') ? '/userGroup/update.do' : '/sign/addTaskInfo.do', this.addForm).then(res => {
            if (!res.data.status) {
              this.$Message.error(res.data.errormsg)
            } else {
              this.$Message.success(this.$i18n.t('tips.save_success'))
              this.add = false
              this.getData()
            }
            this.save_loading = false
          })
        }
      })
    },
    cancelAdd () {
      this.add = false
    },
    getGroup () {
      util.ajax.post('/userGroup/selectAll.do').then(res => {
        if (res.data.status) {
          this.groups = res.data.data
        }
      })
    },
    getData () {
      let qs = require('qs')
      util.ajax.post('/sign/getSignTaskListInfo.do', qs.stringify({
        pageIndex: this.page,
        pageSize: this.pageSize
      })).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          let data = res.data.data
          this.data = data.list
          this.total = data.fullListSize
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
    groupChange (v) {
      if (v === 0) {
        this.$router.push('/data/index')
      }
    }
  },
  created () {
    this.getGroup()
    this.getData()
  }
}
</script>
