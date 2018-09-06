<template>
    <div>
        <Card>
            <p slot="title">
                <Icon type="person"></Icon>
                {{ $t("settings.personal_information") }}
            </p>
            <div>
                <Form
                    ref="userForm"
                    :model="userForm"
                    :label-width="100"
                    label-position="right"
                    :rules="inforValidate"
                >
                    <FormItem :label="$t('settings.userForm.username')" prop="userName">
                        <div style="display:inline-block;width:300px;">
                            <Input v-model="userForm.userName" disabled />
                        </div>
                    </FormItem>
                    <FormItem :label="$t('settings.userForm.email')" prop="email">
                        <div style="display:inline-block;width:300px;">
                            <Input v-model="userForm.email" />
                        </div>
                    </FormItem>
                    <FormItem :label="$t('settings.userForm.language')" prop="language">
                        <div style="display:inline-block;width:300px;">
                          <Select v-model="selected_language" style="width:300px">
                              <Option v-for="item in languages" :value="item" :key="item">{{ item }}</Option>
                          </Select>
                        </div>
                    </FormItem>
                    <FormItem :label="$t('settings.userForm.password')">
                        <Button type="text" size="small" @click="showEditPassword">{{ $t("settings.change_password") }}</Button>
                    </FormItem>
                    <div>
                        <!-- <Button type="text" style="width: 100px;" @click="cancelEditUserInfor">注销帐号</Button> -->
                        <Button type="primary" style="width: 100px;" :loading="save_loading" @click="saveEdit">{{ $t("general.save") }}</Button>
                    </div>
                </Form>
            </div>
        </Card>
        <Modal v-model="editPasswordModal" :closable='false' :mask-closable=false :width="500">
            <h3 slot="header" style="color:#2D8CF0">{{ $t("settings.change_password") }}</h3>
            <Form ref="editPasswordForm" :model="editPasswordForm" :label-width="100" label-position="right" :rules="passwordValidate">
                <FormItem :label="$t('settings.original_password')" prop="oldPass" :error="oldPassError">
                    <Input v-model="editPasswordForm.oldPass" type="password" :placeholder="$t('settings.input_original_password')" />
                </FormItem>
                <FormItem :label="$t('settings.new_password')" prop="newPass">
                    <Input v-model="editPasswordForm.newPass" type="password" :placeholder="$t('settings.input_new_password')" />
                </FormItem>
                <FormItem :label="$t('settings.confirm_new_password')" prop="rePass">
                    <Input v-model="editPasswordForm.rePass" type="password" :placeholder="$t('settings.input_new_password_again')" />
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelEditPass">{{ $t("general.cancel") }}</Button>
                <Button type="primary" :loading="savePassLoading" @click="saveEditPass">{{ $t("general.save") }}</Button>
            </div>
        </Modal>
    </div>
</template>

<script>
import util from '../../libs/util'
import { getLang, setLang } from '@/i18n/config'

export default {
  name: 'ownspace_index',
  data () {
    const valideRePassword = (rule, value, callback) => {
      if (value !== this.editPasswordForm.newPass) {
        callback(new Error(this.$i18n.t('tips.inconsistent_password')))
      } else {
        callback()
      }
    }
    return {
      userForm: {
        userName: '',
        email: '',
        language: ''
      },
      selected_language: getLang(),
      languages: [
        'English',
        '中文(简体)',
        'Deutschland'
      ],
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
          { type: 'email', required: true, message: this.$i18n.t('tips.input_email'), trigger: 'blur' }
        ]
      },
      editPasswordForm: {
        oldPass: '',
        newPass: '',
        rePass: ''
      },
      passwordValidate: {
        oldPass: [
          { required: true, message: this.$i18n.t('settings.input_original_password'), trigger: 'blur' }
        ],
        newPass: [
          { required: true, message: this.$i18n.t('settings.input_new_passoword'), trigger: 'blur' },
          { min: 6, message: this.$i18n.t('tips.min_length'), trigger: 'blur' },
          { max: 32, message: this.$i18n.t('tips.max_length'), trigger: 'blur' }
        ],
        rePass: [
          { required: true, message: this.$i18n.t('settings.input_new_password_again'), trigger: 'blur' },
          { validator: valideRePassword, trigger: 'blur' }
        ]
      },
      inputCodeVisible: false, // 显示填写验证码box
      initPhone: '',
      gettingIdentifyCodeBtnContent: this.$i18n.t('tips.gain_verification_code') // “获取验证码”按钮的文字
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
              this.gettingIdentifyCodeBtnContent = timeLast + this.$i18n.t('tips.retry')
              timeLast -= 1
            } else {
              clearInterval(timer)
              this.gettingIdentifyCodeBtnContent = this.$i18n.t('tips.gain_verification_code')
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
      setLang(this.selected_language)
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
              this.$Message.success(this.$i18n.t('tips.modify_success'))
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
        this.$Message.error(this.$i18n.t('tips.write_verification_code'))
      } else {
        setTimeout(() => {
          this.$Message.success(this.$i18n.t('tips.verify_verification_code'))
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
          this.$Message.success(this.$i18n.t('tips.save_success'))
        }
      })
    }
  },
  mounted () {
    this.init()
  }
}
</script>
