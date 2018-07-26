<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> {{ $t("auditing.data_review") }}</Col>
                    <Col span="4" align="right">
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
        <Modal v-model="add" :closable='false' :mask-closable=false :width="800">
            <h3 slot="header" style="color:#2D8CF0">{{addText}}</h3>
            <Form ref="addForm" label-position="right" :rules="formValidate">
                <FormItem :label="$t('auditing.group_name')" prop="name">
                    <Input :placeholder="$t('auditing.input_group_name')" style="width:60%"></Input>
                </FormItem>
            </Form>
            <Form ref="addForm" label-position="right" :rules="formValidate">
                <FormItem :label="$t('auditing.label')" prop="name">
                    <Input :placeholder="$t('auditing.input_account_or_email')"></Input>
                </FormItem>
            </Form>
            <Form ref="addForm" label-position="right" :rules="formValidate">
                <FormItem :label="$t('auditing.upload')" prop="name">
                    <Input :placeholder="$t('auditing.input_account_or_email')"></Input>
                </FormItem>
            </Form>
            <Form ref="addForm" label-position="right" :rules="formValidate">
                <FormItem :label="$t('auditing.audit')" prop="name">
                    <Input :placeholder="$t('auditing.input_account_or_email')"></Input>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelAdd">{{ $t("general.cancel") }}</Button>
                <Button type="primary" :loading="save_loading" @click="saveAdd">{{ $t("general.submit") }}</Button>
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
          title: this.$t('menus.number'),
          key: 'idTaskInfo'
        },
        {
          title: this.$t('menus.group'),
          key: 'groupName'
        },
        {
          title: this.$t('menus.batch'),
          key: 'taskName'
        },
        {
          title: this.$t('menus.audited'),
          key: 'auditNum'
        },
        {
          title: this.$t('status.to_be_audited'),
          key: 'unAuditNum'
        },
        {
          title: this.$t('status.to_be_labelled'),
          key: 'unSignNum'
        },
        {
          title: this.$t('menus.total'),
          key: 'allNum'
        },
        {
          title: this.$t('menus.create_time'),
          key: 'createdDate',
          width: 200
        },
        {
          title: this.$t('menus.setting'),
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
                    path: '/item/auditing/' + row.idTaskInfo,
                    query: {
                      groupName: row.groupName,
                      taskName: row.taskName
                    }
                  })
                }
              }
            }, '查看'))

            return h('div', buts)
          }
        }
      ],
      data: [
      ],
      add: false,
      addText: this.$t('tagging.create_batch'),
      formValidate: {
        taskName: [
          { required: true, message: this.$t('tagging.input_batch_name'), trigger: 'blur' }
        ],
        idGroup: [
          { required: true, message: this.$t('auditing.choose_group'), trigger: 'change' }
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
      this.addText = this.$t('auditing.create_group')
    },
    showEdit () {
      this.add = true
      this.addText = this.$t('auditing.edit_group')
    },
    saveAdd () {
      this.add = false
      this.$Message.success(this.$t('auditing.create_success'))
    },
    cancelAdd () {
      this.add = false
    },
    getData () {
      let qs = require('qs')
      util.ajax.post('/sign/getAuditTaskListInfo.do', qs.stringify({
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
    }
  },
  created () {
    this.getData()
  }
}
</script>
