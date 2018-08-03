<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> {{ $t("auditing.group_management") }}</Col>
                    <Col span="4" align="right">
                    <Button type="ghost" shape="circle" icon="android-add" @click="showAdd">{{ $t("auditing.add_group") }}</Button></Col>
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
        <Modal v-model="add" :closable='false' :mask-closable=false :width="600">
            <h3 slot="header" style="color:#2D8CF0">{{addText}}</h3>
            <Form ref="addForm" :model="form" label-position="right" :rules="formValidate" :label-width="80">
                <FormItem :label="$t('auditing.group_name')" prop="groupName">
                    <Input v-model="form.groupName" :placeholder="$t('auditing.input_group_name')" style="width:60%"></Input>
                </FormItem>

                <FormItem :label="$t('auditing.upload')" prop="uploadMember">
                   <Select
                        v-model="form.uploadMember"
                        multiple
                        filterable
                        remote
                        :placeholder="$t('auditing.name_or_email')"
                        :remote-method="getUserUploadMember"
                        :loading="loading1"
                        :label="form.uploadMemberLabel">
                        <Option v-for="(option) in uploadMember" :value="option.userId" :key="option.userId" :label="option.userName+'('+option.email+')'">{{option.userName}}({{option.email}})</Option>
                    </Select>
                </FormItem>

                <FormItem :label="$t('auditing.label')" prop="labelMember">
                    <Select
                        v-model="form.labelMember"
                        multiple
                        filterable
                        remote
                        :placeholder="$t('auditing.name_or_email')"
                        :remote-method="getUserLabelMember"
                        :loading="loading2"
                        :label="form.labelMemberLabel">
                        <Option v-for="(option) in labelMember" :value="option.userId" :key="option.userId" :label="option.userName+'('+option.email+')'">{{option.userName}}({{option.email}})</Option>
                    </Select>
                </FormItem>

                <FormItem :label="$t('auditing.audit')" prop="auditMember">
                    <Select
                        v-model="form.auditMember"
                        multiple
                        filterable
                        remote
                        :placeholder="$t('auditing.name_or_email')"
                        :remote-method="getUserAuditMember"
                        :loading="loading3"
                        :label="form.auditMemberLabel">
                        <Option v-for="(option) in auditMember" :value="option.userId" :key="option.userId" :label="option.userName+'('+option.email+')'">{{option.userName}}({{option.email}})</Option>
                    </Select>
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
          type: 'expand',
          width: 40,
          render: (h, params) => {
            return h(expandRow, {
              props: {
                row: params.row
              }
            })
          }
        },
        {
          title: this.$i18n.t('menus.group'),
          key: 'name'
        },
        {
          title: this.$i18n.t('menus.create_time'),
          key: 'createdDate'
        },
        {
          title: this.$i18n.t('menus.setting'),
          key: 'action',
          width: 160,
          render: (h, params) => {
            const row = params.row
            let buts = []
            buts.push(h('Button', {
              props: {
                type: 'text',
                size: 'small'
              },
              on: {
                click: () => {
                  this.$router.push('/tagging/index')
                }
              }
            }, this.$i18n.t('general.review')))
            // if (row.status === '1') {
            buts.push(h('Button', {
              props: {
                type: 'text',
                size: 'small'
              },
              on: {
                click: () => {
                  this.form = {}
                  this.form = {
                    idGroup: row.idGroup,
                    groupName: row.name,
                    uploadMember: (row.uploadMemberList || []).map(v => {
                      return v.userId
                    }),
                    labelMember: (row.labelMemberList || []).map(v => {
                      return v.userId
                    }),
                    auditMember: (row.auditMemberList || []).map(v => {
                      return v.userId
                    }),
                    uploadMemberLabel: (row.uploadMemberList || []).map(v => {
                      return v.userName + '(' + v.email + ')'
                    }),
                    labelMemberLabel: (row.labelMemberList || []).map(v => {
                      return v.userName + '(' + v.email + ')'
                    }),
                    auditMemberLabel: (row.auditMemberList || []).map(v => {
                      return v.userName + '(' + v.email + ')'
                    })
                  }
                  this.uploadMember = row.uploadMemberList
                  this.labelMember = row.labelMemberList
                  this.auditMember = row.auditMemberList
                  this.showEdit()
                }
              }
            }, this.$i18n.t('general.edit')))
            buts.push(h('Poptip', {
              props: {
                confirm: true,
                title: this.$i18n.t('tips.cancel_tip'),
                transfer: true
              },
              on: {
                'on-ok': () => {
                  this.data.splice(row.index, 1)
                  // this.$emit('input', vm.handleBackdata(vm.thisTableData));
                  this.deleteItem(row.idGroup)
                }
              }
            }, [
              h('Button', {
                style: {
                  color: 'red'
                },
                props: {
                  type: 'text',
                  placement: 'top',
                  size: 'small'
                }
              }, this.$i18n.t('general.delete'))
            ]))
            // }

            return h('div', buts)
          }
        }
      ],
      data: [],
      add: false,
      addText: this.$i18n.t('auditing.create_group'),
      formValidate: {
        groupName: [
          { required: true, message: this.$i18n.t('tips.invalid_group'), trigger: 'blur' }
        ]
      },
      save_loading: false,
      total: 0,
      pageSize: 10,
      page: 1,
      loading1: false,
      loading2: false,
      loading3: false,
      form: {
        groupName: '',
        uploadMember: [],
        labelMember: [],
        auditMember: []
      },
      uploadMember: [],
      labelMember: [],
      auditMember: []
    }
  },
  methods: {
    showAdd () {
      this.add = true
      this.addText = this.$i18n.t('auditing.create_group')
      this.form = {
        groupName: '',
        uploadMember: [],
        labelMember: [],
        auditMember: []
      }
    },
    showEdit () {
      this.add = true
      this.addText = this.$i18n.t('auditing.edit_group')
    },
    saveAdd () {
      this.save_loading = true
      this.$refs.addForm.validate((valid) => {
        if (valid) {
          util.ajax.post(this.addText === this.$i18n.t('auditing.edit_group') ? '/userGroup/update.do' : '/userGroup/save.do', this.form).then(res => {
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
    getData () {
      let qs = require('qs')
      util.ajax.post('/userGroup/selectGroupList.do', qs.stringify({
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
    getUserUploadMember (query) {
      this.loading1 = true
      if (query.length > 0) { this.getUser(query, 'uploadMember') }
    },
    getUserLabelMember (query) {
      this.loading2 = true
      if (query.length > 0) { this.getUser(query, 'labelMember') }
    },
    getUserAuditMember (query) {
      this.loading3 = true
      if (query.length > 0) { this.getUser(query, 'auditMember') }
    },
    getUser (query, type) {
      util.ajax.post('/userGroup/userNameIsExist.do', 'name=' + query).then(res => {
        if (res.data.status) {
          this[type] = res.data.data
        }
        this.loading1 = false
        this.loading2 = false
        this.loading3 = false
      })
    },
    deleteItem (idGroup) {
      util.ajax.post('/userGroup/delete.do', 'idGroup=' + idGroup).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          this.$Message.success(this.$i18n.t('tips.deleted'))
        }
      })
    }
  },
  created () {
    this.getData()
  }
}
</script>
