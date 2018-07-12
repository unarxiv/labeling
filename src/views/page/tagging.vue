<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> 数据标注</Col>
                    <Col span="4" align="right">
                    <Button type="ghost" shape="circle" icon="android-add" @click="showAdd">添加批次</Button>
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
                <FormItem label="批次名" prop="taskName">
                    <Input v-model="addForm.taskName" placeholder="请输入批次名"></Input>
                </FormItem>
                <FormItem label="所属分组" prop="idGroup">
                    <Select v-model="addForm.idGroup" placeholder="选择分组" @on-change="groupChange">
                        <Option v-for="(item,key) in groups" :value="item.idGroup+''" :key="key" :label="item.name">{{item.name}}</Option>
                        <Option :value="0" key="" label="" style="text-align:center">--- 添加新分组 ---</Option>
                    </Select>
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
                    path: '/item/tagging/' + row.idTaskInfo,
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
      this.addText = '创建批次'
      this.addForm = {
        taskName: '',
        idGroup: ''
      }
    },
    showEdit () {
      this.add = true
      this.addText = '编辑批次'
    },
    saveAdd () {
      this.$refs.addForm.validate((valid) => {
        if (valid) {
          this.save_loading = true
          util.ajax.post(this.addText === '编辑批次' ? '/userGroup/update.do' : '/sign/addTaskInfo.do', this.addForm).then(res => {
            if (!res.data.status) {
              this.$Message.error(res.data.errormsg)
            } else {
              this.$Message.success('保存成功！')
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
