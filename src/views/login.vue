<template>
    <div class="login">
      <div class="login-nav">
        <top-menu></top-menu>
      </div>
        <div class="login-con">
            <Card :bordered="false">
                <Tabs v-model="currentTab">
                    <TabPane label="登录" name="login">
                      <div v-if="isLogin" class="form-con">
                        <Button @click="go('/index')" type="primary" long>{{userName}},你已经登录。点击进控制台</Button>
                        <br/> <br/>
                        <Button @click="handleOut" type="text" long>退出重新登录</Button>
                      </div>
                        <div v-else class="form-con" @keydown.enter="handleSubmit" >
                            <Form ref="loginForm" :model="form" :rules="rules">
                                <FormItem prop="loginName">
                                    <Input v-model="form.loginName" placeholder="请输入用户名|邮箱地址">
                                        <!-- <span slot="prepend">
                                            <Icon :size="16" type="person"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem prop="password">
                                    <Input type="password" v-model="form.password" placeholder="请输入密码">
                                        <!-- <span slot="prepend">
                                            <Icon :size="14" type="locked"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <p :style="{'text-align':'right'}">
                                    <Button @click="showForget" type="text">忘记密码？</Button>
                                </p>
                                <FormItem>
                                    <Button @click="handleSubmit" type="primary" long>登录</Button>
                                </FormItem>
                            </Form>
                        </div>
                    </TabPane>
                    <TabPane label="注册" name="reg">
                        <div class="form-con">
                            <Form ref="regForm" :model="regForm" :rules="regFormValidate">
                                <FormItem prop="loginName">
                                    <Input v-model="regForm.loginName" placeholder="请输入用户名">
                                        <!-- <span slot="prepend">
                                            <Icon :size="16" type="person"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem prop="email">
                                    <Input v-model="regForm.email" placeholder="请输入邮箱">
                                        <!-- <span slot="prepend">
                                            <Icon :size="16" type="email"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem prop="oldPassWord">
                                    <Input type="password" v-model="regForm.oldPassWord" placeholder="请输入密码">
                                        <!-- <span slot="prepend">
                                            <Icon :size="14" type="locked"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem prop="newPassWord">
                                    <Input type="password" v-model="regForm.newPassWord" placeholder="请再次输入密码">
                                        <!-- <span slot="prepend">
                                            <Icon :size="14" type="locked"></Icon>
                                        </span> -->
                                    </Input>
                                </FormItem>
                                <FormItem>
                                    <Button @click="handleRegSubmit" type="primary" long>注册</Button>
                                </FormItem>
                            </Form>
                        </div>
                    </TabPane>
                </Tabs>

            </Card>
        </div>
        <Modal v-model="forget" :closable='false' :mask-closable=false :width="400">
            <h3 slot="header" style="color:#2D8CF0">找回密码</h3>
            <Form ref="forgetForm" :model="forgetForm" :label-width="60" label-position="right"
             :rules="forgetValidate">
                <FormItem label="邮箱" prop="email" :error="emailError">
                    <Input v-model="forgetForm.email" placeholder="请输入注册时的邮箱" ></Input>
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="cancelForget">取消</Button>
                <Button type="primary" :loading="forgetLoading" @click="submitForget">提交</Button>
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
        callback(new Error('两次输入密码不一致'))
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
          { required: true, message: '账号不能为空', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '密码不能为空', trigger: 'blur' }
        ]
      },
      regFormValidate: {
        loginName: [
          { required: true, message: '请输入登录名', trigger: 'blur' }
        ],
        email: [
          { type: 'email', required: true, message: '请输入常用邮箱', trigger: 'blur' }
        ],
        oldPassWord: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, message: '请至少输入6个字符', trigger: 'blur' },
          { max: 32, message: '最多输入32个字符', trigger: 'blur' }
        ],
        newPassWord: [
          { required: true, message: '请再次输入密码', trigger: 'blur' },
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
          { type: 'email', required: true, message: '请输入注册时的邮箱', trigger: 'blur' }
        ]
      },
      emailError: '',
      forgetLoading: false,
      isLogin: !!Cookies.get('user')
    }
  },
  computed: {

    userName () {
      return Cookies.get('user')
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

              this.$Message.success('登录成功！')
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
                this.$Message.success('注册成功！')
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
                this.$Message.success('密码已经发送到你的邮箱，请查收')
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
            localStorage.removeItem('token')
            this.isLogin = false
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
</style>
