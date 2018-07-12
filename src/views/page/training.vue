<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> 模型训练</Col>
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
          title: '编号',
          key: 'idTaskInfo'
        },
        {
          title: '分组',
          key: 'groupName'
        },
        {
          title: '批次',
          key: 'taskName'
        },
        {
          title: '已审核',
          key: 'auditNum'
        },
        {
          title: '待审核',
          key: 'unAuditNum'
        },
        {
          title: '待标注',
          key: 'unSignNum'
        },
        {
          title: '总数',
          key: 'allNum'
        },
        {
          title: '创建时间',
          key: 'createdDate',
          width: 200
        },
        {
          title: '操作',
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
            }, '去提交训练'))

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
            }, '训练记录'))

            return h('div', buts)
          }
        }
      ],
      data: [
      ],
      add: false,
      addText: '创建分组',
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
      this.addText = '创建分组'
    },
    showEdit () {
      this.add = true
      this.addText = '编辑分组'
    },
    saveAdd () {
      this.add = false
      this.$Message.success('创建成功')
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
  created () {
    this.getGroup()
    this.getData()
  }
}
</script>
