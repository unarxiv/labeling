<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> {{groupName}} - {{taskName}} 训练记录</Col>
                    <Col span="4" align="right"></Col>
                </Row>
            </p>
            <div>
              <Table :columns="columns" :data="data"></Table>
              <!-- <p style="padding-top:10px; text-align:right">
                  <Page :total="total" :page-size="pageSize"
                  @on-change="pageChange"
                  @on-page-size-change="pageSizeChange"
                  size="small" show-elevator show-sizer show-total></Page>
              </p> -->
            </div>
        </Card>
    </div>
</template>
<script>
import util from '../../libs/util'
export default {
  components: {
  },
  data () {
    return {
      columns: [
        {
          title: '时间',
          key: 'createdDate'
        },
        {
          title: '文件名',
          key: 'logFileName'
        },
        {
          title: '提交人',
          key: 'userName'
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
                    path: '/trainlog/' + row.idTrainInfo,
                    query: {
                      groupName: this.groupName,
                      taskName: this.taskName,
                      modelId: row.logFileName
                    }
                  })
                }
              }
            }, '查看详情'))

            buts.push(h('Button', {
              props: {
                size: 'small'
              },
              on: {
                click: () => {
                  this.$router.push({
                    path: '/train/' + row.idTrainInfo,
                    query: {
                      groupName: this.groupName,
                      taskName: this.taskName
                    }
                  })
                }
              }
            }, '重新提交'))

            buts.push(h('Button', {
              props: {
                size: 'small'
              },
              on: {
                click: () => {
                  this.$router.push({
                    path: '/trainTest/' + row.idTrainInfo,
                    query: {
                      groupName: this.groupName,
                      taskName: this.taskName,
                      modelId: row.logFileName
                    }
                  })
                }
              }
            }, '测试'))

            return h('div', buts)
          }
        }
      ],
      data: [
        {'createdBy': '35', 'createdDate': '2018-06-14 09:56:00', 'idTrainInfo': '15', 'logFileName': 'xxx'}
      ],
      total: 0,
      pageSize: 10,
      page: 1
    }
  },
  methods: {
    getData () {
      let self = this
      let qs = require('qs')
      util.ajax.get('/train/getTrainList.do?' + qs.stringify({
        pageIndex: this.page,
        pageSize: this.pageSize,
        idTaskInfo: this.id
      })).then((res) => {
        if (!res.data.status) {
          self.$Message.error(res.data.errormsg)
        } else {
          self.data = res.data.data.list
          console.log(self.data)
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
    this.id = this.$route.params.id
    this.groupName = this.$route.query.groupName
    this.taskName = this.$route.query.taskName
    this.getData()
  }
}
</script>
