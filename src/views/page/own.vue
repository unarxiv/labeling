<template>
    <div>
        <Card>
            <p slot="title">
                <Icon type="person"></Icon>
                个人信息
            </p>
            <div>
                <Form
                    ref="userForm"
                    :model="userForm"
                    :label-width="100"
                    label-position="right"
                    :rules="inforValidate"
                >
                    <FormItem label="用户名：" prop="userName">
                        <div style="display:inline-block;width:300px;">
                            <Input v-model="userForm.userName" disabled></Input>
                        </div>
                    </FormItem>
                    <FormItem label="邮箱：" prop="email">
                        <div style="display:inline-block;width:300px;">
                            <Input v-model="userForm.email" ></Input>
                        </div>
                    </FormItem>
                    <FormItem label="登录密码：">
                        <Button type="text" size="small" @click="showEditPassword">修改密码</Button>
                    </FormItem>
                    <div>
                        <!-- <Button type="text" style="width: 100px;" @click="cancelEditUserInfor">注销帐号</Button> -->
                        <Button type="primary" style="width: 100px;" :loading="save_loading" @click="saveEdit">保存</Button>
                    </div>
                </Form>
            </div>
        </Card>
        <Modal v-model="editPasswordModal" :closable='false' :mask-closable=false :width="500">
            <h3 slot="header" style="color:#2D8CF0">修改密码</h3>
            <Form ref="editPasswordForm" :model="editPasswordForm" :label-width="100" label-position="right" :rules="passwordValidate">
                <FormItem label="原密码" prop="oldPass" :error="oldPassError">
                    <Input v-model="editPasswordForm.oldPass" type="password" placeholder="请输入现在使用的密码" ></Input>
                </FormItem>
                <FormItem label="新密码" prop="newPass">
                    <Input v-model="editPasswordForm.newPass" type="password" placeholder="请输入新密码，至少6位字符" ></Input>
                </FormItem>
                <FormItem label="确认新密码" prop="rePass">
                    <Input v-model="editPasswordForm.rePass" type="password" placeholder="请再次输入新密码" ></Input>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelEditPass">取消</Button>
                <Button type="primary" :loading="savePassLoading" @click="saveEditPass">保存</Button>
            </div>
        </Modal>
    </div>
</template>

<script>
import util from '../../libs/util'

export default {
  name: 'ownspace_index',
  data () {
    const valideRePassword = (rule, value, callback) => {
      if (value !== this.editPasswordForm.newPass) {
        callback(new Error('两次输入密码不一致'))
      } else {
        callback()
      }
    }
    return {
      userForm: {
        userName: '',
        email: ''
      },
      uid: '', // 登录用户的userId
      securityCode: '', // 验证码
      phoneHasChanged: false, // 是否编辑了手机
      save_loading: false,
      identifyError: '', // 验证码错误
      editPasswordModal: false, // 修改密码模态框显示
      savePassLoading: false,
      oldPassError: '',
      identifyCodeRight: false, // 验证码是否正确
      hasGetIdentifyCode: false, // 是否点了获取验证码
      canGetIdentifyCode: false, // 是否可点获取验证码
      checkIdentifyCodeLoading: false,
      inforValidate: {
        email: [
          { type: 'email', required: true, message: '请输入常用邮箱', trigger: 'blur' }
        ]
      },
      editPasswordForm: {
        oldPass: '',
        newPass: '',
        rePass: ''
      },
      passwordValidate: {
        oldPass: [
          { required: true, message: '请输入原密码', trigger: 'blur' }
        ],
        newPass: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, message: '请至少输入6个字符', trigger: 'blur' },
          { max: 32, message: '最多输入32个字符', trigger: 'blur' }
        ],
        rePass: [
          { required: true, message: '请再次输入新密码', trigger: 'blur' },
          { validator: valideRePassword, trigger: 'blur' }
        ]
      },
      inputCodeVisible: false, // 显示填写验证码box
      initPhone: '',
      gettingIdentifyCodeBtnContent: '获取验证码' // “获取验证码”按钮的文字
    }
  },
  methods: {
    getIdentifyCode () {
      this.hasGetIdentifyCode = true
      this.$refs['userForm'].validate((valid) => {
        if (valid) {
          this.canGetIdentifyCode = true
          let timeLast = 60
          let timer = setInterval(() => {
            if (timeLast >= 0) {
              this.gettingIdentifyCodeBtnContent = timeLast + '秒后重试'
              timeLast -= 1
            } else {
              clearInterval(timer)
              this.gettingIdentifyCodeBtnContent = '获取验证码'
              this.canGetIdentifyCode = false
            }
          }, 1000)
          this.inputCodeVisible = true
          // you can write ajax request here
        }
      })
    },
    showEditPassword () {
      this.editPasswordModal = true
    },
    cancelEditUserInfor () {
      this.$store.commit('removeTag', 'ownspace_index')
      localStorage.pageOpenedList = JSON.stringify(this.$store.state.app.pageOpenedList)
      let lastPageName = ''
      if (this.$store.state.app.pageOpenedList.length > 1) {
        lastPageName = this.$store.state.app.pageOpenedList[1].name
      } else {
        lastPageName = this.$store.state.app.pageOpenedList[0].name
      }
      this.$router.push({
        name: lastPageName
      })
    },
    saveEdit () {
      this.$refs['userForm'].validate((valid) => {
        if (valid) {
          this.saveInfoAjax()
        }
      })
    },
    cancelEditPass () {
      this.editPasswordModal = false
    },
    saveEditPass () {
      this.$refs['editPasswordForm'].validate((valid) => {
        if (valid) {
          this.savePassLoading = true
          util.ajax.post('/user/updateUserPassword.do', {
            oldPassWord: this.editPasswordForm.oldPass,
            newPassWord: this.editPasswordForm.newPass
          }).then(res => {
            this.savePassLoading = false

            if (!res.data.status) {
              this.$Message.error(res.data.errormsg)
            } else {
              this.$Message.success('修改成功！')
              this.editPasswordModal = false
            }
          })
        }
      })
    },
    init () {
      util.ajax.post('/user/getSignUserInfomation.do').then(res => {
        if (res.data.status) {
          let data = res.data.data
          this.userForm.userName = data.userName
          this.userForm.email = data.email
        }
      })
    },
    cancelInputCodeBox () {
      this.inputCodeVisible = false
      this.userForm.cellphone = this.initPhone
    },
    submitCode () {
      let vm = this
      vm.checkIdentifyCodeLoading = true
      if (this.securityCode.length === 0) {
        this.$Message.error('请填写短信验证码')
      } else {
        setTimeout(() => {
          this.$Message.success('验证码正确')
          this.inputCodeVisible = false
          this.checkIdentifyCodeLoading = false
        }, 1000)
      }
    },
    hasChangePhone () {
      this.phoneHasChanged = true
      this.hasGetIdentifyCode = false
      this.identifyCodeRight = false
    },
    saveInfoAjax () {
      this.save_loading = true
      util.ajax.post('/user/updateUserInformation.do', this.userForm).then(res => {
        this.save_loading = false
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          this.$Message.success('保存成功！')
        }
      })
    }
  },
  mounted () {
    this.init()
  }
}
</script>
