<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> {{ $t("training.model_training") }}</Col>
                    <Col span="4" align="right"/>
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
          width: 260,
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
                    path: '/item/training/' + row.idTaskInfo,
                    query: {
                      groupName: row.groupName,
                      taskName: row.taskName
                    }
                  })
                }
              }
            }, this.$i18n.t('table.submit_train')))

            buts.push(h('Button', {
              props: {
                size: 'small'
              },
              on: {
                click: () => {
                  this.$router.push({
                    path: '/trainlist/' + row.idTaskInfo,
                    query: {
                      groupName: row.groupName,
                      taskName: row.taskName
                    }
                  })
                }
              }
            }, this.$i18n.t('table.train_record')))

            return h('div', buts)
          }
        }
      ],
      data: [
      ],
      add: false,
      addText: this.$i18n.t('auditing.create_group'),
      formValidate: {},
      save_loading: false,
      total: 0,
      pageSize: 10,
      page: 1
    }
  },
  methods: {
    showAdd () {
      this.add = true
      this.addText = this.$i18n.t('auditing.create_group')
    },
    showEdit () {
      this.add = true
      this.addText = this.$i18n.t('auditing.edit_group')
    },
    saveAdd () {
      this.add = false
      this.$Message.success(this.$i18n.t('auditing.create_success'))
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
      util.ajax.post('/sign/getTrainTaskListInfo.do', qs.stringify({
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
  mounted () {
  },
  created () {
    this.getGroup()
    this.getData()
  }
}
</script>
