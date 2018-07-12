<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> 数据审核</Col>
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
                <FormItem label="分组名称" prop="name">
                    <Input placeholder="请输入分组名" style="width:60%"></Input>
                </FormItem>
            </Form>
            <Form ref="addForm" label-position="right" :rules="formValidate">
                <FormItem label="标注人员" prop="name">
                    <Input placeholder="请输入帐号或邮箱，多个用‘,’分开"></Input>
                </FormItem>
            </Form>
            <Form ref="addForm" label-position="right" :rules="formValidate">
                <FormItem label="上传人员" prop="name">
                    <Input placeholder="请输入帐号或邮箱，多个用‘,’分开"></Input>
                </FormItem>
            </Form>
            <Form ref="addForm" label-position="right" :rules="formValidate">
                <FormItem label="审核人员" prop="name">
                    <Input placeholder="请输入帐号或邮箱，多个用‘,’分开"></Input>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelAdd">取消</Button>
                <Button type="primary" :loading="save_loading" @click="saveAdd">提交</Button>
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
          title: '设置',
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
      addText: '创建批次',
      formValidate: {
        taskName: [
          { required: true, message: '请填写批次名', trigger: 'blur' }
        ],
        idGroup: [
          { required: true, message: '请选择分组', trigger: 'change' }
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
