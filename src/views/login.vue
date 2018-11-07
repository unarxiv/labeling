<template>
    <div class="login">
      <div class="login-nav">
        <top-menu></top-menu>
      </div>
        <div class="login-con">
            <Card :bordered="false">
                <Tabs v-model="currentTab">
                    <TabPane :label="$t('menus.login')" name="login">
                      <div v-if="isLogin" class="form-con">
                        <Button @click="go('/index')" type="primary" long>{{userName}},{{ $t("tips.logged_in") }}</Button>
                        <br/> <br/>
                        <Button @click="handleOut" type="text" long>{{ $t('tips.relogin') }}</Button>
                      </div>
                        <div v-else class="form-con" @keydown.enter="handleSubmit" >
                            <Form ref="loginForm" :model="form" :rules="rules">
                                <FormItem prop="loginName">
                                    <Input v-model="form.loginName" :placeholder="$t('tips.input_name_or_email')">
                                        <!-- <span slot="prepend">
                                            <Icon :size="16" type="person"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem prop="password">
                                    <Input type="password" v-model="form.password" :placeholder="$t('tips.input_password')">
                                        <!-- <span slot="prepend">
                                            <Icon :size="14" type="locked"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <p :style="{'text-align':'right'}">
                                    <Button @click="showForget" type="text">{{ $t('tips.forgot_password') }}</Button>
                                </p>
                                <FormItem>
                                    <Button @click="handleSubmit" type="primary" long>{{ $t("menus.login") }}</Button>
                                </FormItem>
                            </Form>
                        </div>
                    </TabPane>
                    <TabPane :label="$t('menus.sign_up')" name="reg">
                        <div class="form-con">
                            <Form ref="regForm" :model="regForm" :rules="regFormValidate">
                                <FormItem prop="loginName">
                                    <Input v-model="regForm.loginName" :placeholder="$t('tips.input_name')">
                                        <!-- <span slot="prepend">
                                            <Icon :size="16" type="person"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem prop="email">
                                    <Input v-model="regForm.email" :placeholder="$t('tips.input_email')">
                                        <!-- <span slot="prepend">
                                            <Icon :size="16" type="email"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem prop="oldPassWord">
                                    <Input type="password" v-model="regForm.oldPassWord" :placeholder="$t('tips.input_password')">
                                        <!-- <span slot="prepend">
                                            <Icon :size="14" type="locked"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem prop="newPassWord">
                                    <Input type="password" v-model="regForm.newPassWord" :placeholder="$t('tips.input_password_again')">
                                        <!-- <span slot="prepend">
                                            <Icon :size="14" type="locked"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem>
                                    <Button @click="handleRegSubmit" type="primary" long>{{ $t('menus.sign_up') }}</Button>
                                </FormItem>
                            </Form>
                        </div>
                    </TabPane>
                </Tabs>

            </Card>
        </div>
        <div class="login-contrib">
          <img src="@/assets/logo/szu.png" class="contrib-logo"/>
          <img src="@/assets/logo/iacas.png" class="contrib-logo"/>
          <img src="@/assets/logo/watrix.png" class="contrib-logo"/>
          <img src="@/assets/logo/jingxinwei.png" class="contrib-logo"/>
        </div>
        <Modal v-model="forget" :closable='false' :mask-closable=false :width="400">
            <h3 slot="header" style="color:#2D8CF0">{{ $t("tips.forgot_password") }}</h3>
            <Form ref="forgetForm" :model="forgetForm" :label-width="60" label-position="right"
             :rules="forgetValidate">
                <FormItem :label="$t('userForm.email')" prop="email" :error="emailError">
                    <Input v-model="forgetForm.email" :placeholder="$t('tips.input_registered_email')" ></Input>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelForget">{{ $t("general.cancel") }}</Button>
                <Button type="primary" :loading="forgetLoading" @click="submitForget">{{ $t('general.submit') }}</Button>
            </div>
        </Modal>
    </div>
</template>

<script>
import Cookies from 'js-cookie'
import util from '../libs/util'
import TopMenu from './main/topmenu'
export default {
  data () {
    const valideRePassword = (rule, value, callback) => {
      if (value !== this.regForm.newPassWord) {
        callback(new Error(this.$i18n.t('tips.inconsistent_password')))
      } else {
        callback()
      }
    }
    return {
      form: {
        loginName: '',
        password: ''
      },
      regForm: {
        loginName: '',
        oldPassWord: '',
        newPassWord: '',
        email: ''
      },
      rules: {
        loginName: [
          { required: true, message: this.$i18n.t('tips.invalid_account'), trigger: 'blur' }
        ],
        password: [
          { required: true, message: this.$i18n.t('tips.invalid_password'), trigger: 'blur' }
        ]
      },
      regFormValidate: {
        loginName: [
          { required: true, message: this.$i18n.t('tips.input_name'), trigger: 'blur' }
        ],
        email: [
          { type: 'email', required: true, message: this.$i18n.t('tips.input_email'), trigger: 'blur' }
        ],
        oldPassWord: [
          { required: true, message: this.$i18n.t('tips.input_password'), trigger: 'blur' },
          { min: 6, message: this.$i18n.t('tips.min_length'), trigger: 'blur' },
          { max: 32, message: this.$i18n.t('tips.max_length'), trigger: 'blur' }
        ],
        newPassWord: [
          { required: true, message: this.$i18n.t('tips.input_password_again'), trigger: 'blur' },
          { validator: valideRePassword, trigger: 'blur' }
        ]
      },
      currentTab: '',
      forget: false,
      forgetForm: {
        email: ''
      },
      forgetValidate: {
        email: [
          { type: 'email', required: true, message: this.$i18n.t('tips.input_registered_email'), trigger: 'blur' }
        ]
      },
      emailError: '',
      forgetLoading: false
    }
  },
  computed: {

    userName () {
      return Cookies.get('user')
    },
    isLogin () {
      return this.$store.state.login
    }
  },
  components: {
    TopMenu
  },
  methods: {
    handleSubmit () {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          util.ajax.post('/user/login.do', this.form)
            .then((res) => {
              if (!res.data.status) {
                this.$Message.error(res.data.errormsg)
                return
              }
              Cookies.set('user', this.form.loginName)
              Cookies.set('access', 1)
              localStorage.setItem('token', res.data.data.token)
              this.$store.commit('setLogin')
              this.$Message.success(this.$i18n.t('tips.login_success'))
              this.$router.push({
                name: 'home'
              })
            }).catch((e) => {
              console.log(e)
            })
        }
      })
    },
    handleRegSubmit () {
      this.$refs.regForm.validate((valid) => {
        if (valid) {
          util.ajax.post('/user/register.do', this.regForm)
            .then((res) => {
              if (res.data.status) {
                this.$Message.success(this.$i18n.t('tips.sign_up_success'))
                this.currentTab = 'login'
                this.form.loginName = this.regForm.loginName
                this.regForm = {
                  loginName: '',
                  oldPassWord: '',
                  newPassWord: '',
                  email: ''
                }
              } else {
                this.$Message.error(res.data.errormsg)
              }
            })
            .catch((e) => {
              console.log(e)
            })
        }
      })
    },
    showForget () {
      this.forget = true
      this.forgetForm.email = ''
      this.forgetLoading = false
    },
    cancelForget () {
      this.forget = false
    },
    submitForget () {
      this.$refs.forgetForm.validate((valid) => {
        if (valid) {
          this.forgetLoading = true
          util.ajax.post('/user/resetPassByMail.do', 'email=' + this.forgetForm.email)
            .then((res) => {
              this.forgetLoading = false
              if (!res.data.status) {
                this.emailError = res.data.errormsg
              } else {
                this.$Message.success(this.$i18n.t('tips.password_send_to_email'))
                this.forget = false
              }
            }).catch((e) => {
              console.log(e)
            })
        }
      })
    },
    go (url) {
      this.$router.push(url)
    },
    loginout () {
      util.ajax.post('/user/logout.do')
        .then((res) => {
          if (res.data.status) {
            this.$Message.success(res.data.data)
            // 退出登录
            Cookies.remove('user')
            this.$store.commit('loginOut')
            localStorage.removeItem('token')
            this.$router.push('/')
          } else {
            this.$Message.error(res.data.errormsg)
          }
        })
        .catch((e) => {
          console.log(e)
        })
    },
    handleOut () {
      this.$router.push({path: '/', query: {out: true}})
    }
  },
  watch: {
    '$route': function (r) {
      if (r.query.out) {
        this.loginout && this.loginout()
      }
    }
  },
  created () {
    if (this.$route.query.out) {
      this.loginout()
    }
    this.$store.commit('setLogin')
  }
}
</script>

<style lang="less">
  .login{
    width: 100%;
    height: 100%;
    background-image: url('../assets/images/login-bg.jpg');
    background-size: cover;
    background-position: center;
    position: relative;

    .login-nav{
      background-color: rgba(0,0,0,.5);
      height: 60px;

      .ivu-menu-dark{
        background-color: transparent;

      }
      .layout-nav{
        width: 1000px;
        margin: 0 auto;
      }
    }

    &-con{
        position: absolute;
        right: 18%;
        top: 50%;
        transform: translateY(-65%);
        width: 300px;

        .ivu-card{
          border-radius: 0;
          background-color: transparent;

          .ivu-card-body{
            padding:0;

            .ivu-tabs-nav{
              width: 100%;
              background-color: #fff;

              .ivu-tabs-tab{
                width: 50%;
                text-align: center;
                padding: 16px 0;
                margin-right: 0;
                font-size: 16px;
                border-bottom: 1px solid #E5E5E5;
              }
            }
            .ivu-tabs-bar{
              margin-bottom: 0;
            }
            .form-con{
              padding: 24px 16px 16px 16px;
              background-color: #fff;
            }
          }
        }

        &-header{
            font-size: 16px;
            font-weight: 300;
            text-align: center;
            padding: 30px 0;
        }
        .login-tip{
            font-size: 10px;
            text-align: center;
            color: #c3c3c3;
        }

    }
}
.login-contrib {
  position: absolute;
  right: 20%;
  top: 80%;
  width: 60%;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
}
.contrib-logo {
  align-self: center;
  width: 20%;
  margin-left: 20px;
  min-width: 20%;
}
</style>
