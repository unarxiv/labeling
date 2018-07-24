<template>
    <div class="layout-home">
      <Card>
            <p slot="title" class="title">
                {{ $t("menus.welcome") }}
            </p>
            <Row>
                <Col span="2">&nbsp;</Col>
                <Col span="4" v-for="(i,k) in list" :key="k" class="item">
                  <Button type="ghost" shape="circle" :icon="i.icon" @click="go(i.children[0].name)"></Button>
                  <p>{{i.title}}</p>
                </Col>
                <Col span="2">&nbsp;</Col>
            </Row>
        </Card>
    </div>
</template>
<script>
import { appRouter } from '../../router/router'

export default {
  name: 'tagging',
  data () {
    return {
      list: appRouter
    }
  },
  methods: {
    go (name) {
      this.$router.push({name: name})
    }
  }
}
</script>
<style lang="less" scoped>
.layout-home{
  .title{
    overflow: visible;
    font-size: 18px;
    text-align: center;
    font-weight: 200;
  }
  .item {
    text-align: center;
    margin: 50px auto;
    &>p{
      font-size: 16px;
      line-height: 4em;
    }

    button{
      font-size: 50px;
      width: 120px;
      height: 120px;
    }
  }
}
</style>
