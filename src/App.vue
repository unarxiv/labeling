<template>
    <router-view/>
</template>

<script>
import { loadDefautlLang } from '@/i18n/config'
export default {
  name: 'App',
  created () {
    loadDefautlLang()
  }
}
</script>

<style>
html,body{
    width: 100%;
    height: 100%;
    background: #f0f0f0;
    overflow: hidden;
}

.ivu-btn-primary {
    color: #fff;
    background-color: #1799A4;
    border-color: #1799A4;
}
.ivu-btn-primary.active, .ivu-btn-primary:active {
    color: #f2f2f2;
    background-color: #1DC1CF;
    border-color: #1DC1CF;
}
.ivu-btn-primary:hover {
    color: #fff;
    background-color: #1DC1CF;
    border-color: #1799A4;
}
.ivu-input,.ivu-btn{
    border-radius: 0;
}
.ivu-card-bordered{
    border: 0;
    border-radius: 0;
}
.ivu-card-bordered:hover{
    box-shadow: 0 0px 0px rgba(0,0,0,.0);
}
.ivu-collapse {
    background-color: #f7f7f7;
    border-radius: 0;
    border: 0px solid #dddee1;
}
.ivu-card-head{
    padding: 16px 30px;
}
.ivu-card-body{
    padding: 20px 30px;
}
</style>
