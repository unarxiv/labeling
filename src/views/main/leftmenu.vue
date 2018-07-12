<template>
    <div>
        <div style="height:40px;"></div>
        <Menu :active-name="selectNode" theme="dark" width="auto" :class="menuitemClasses" @on-select="changeMenu">
            <template v-for="(i,k) in navList">
                <menu-item :name="i.children[0].name" :key="k">
                    <Icon :type="i.icon"></Icon>
                    <span>{{i.title}}</span>
                </menu-item>
            </template>
        </Menu>
    </div>
</template>
<script>
import { appRouter } from '../../router/router'
export default {
  name: 'leftMenu',
  props: {
    isCollapsed: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      navList: appRouter
    }
  },
  computed: {
    menuitemClasses: function () {
      return [
        'menu-item',
        this.isCollapsed ? 'collapsed-menu' : ''
      ]
    },
    selectNode: function () {
      let name = this.$route.name
      switch (name) {
        // case 'tools' : name = 'page-tagging'
        //   break
        case 'train' : name = 'page-training'
          break
        case 'trainlog' : name = 'page-training'
          break
        case 'trainlist' : name = 'page-training'
          break
        case 'item-info' :
          let path = this.$route.path
          if (path.indexOf('auditing') > -1) {
            name = 'page-auditing'
          } else if (path.indexOf('tagging') > -1) {
            name = 'page-tagging'
          } else if (path.indexOf('training') > -1) {
            name = 'page-training'
          }
          break
      }
      return name
    }
  },
  methods: {
    changeMenu (active) {
      this.$router.push({
        name: active
      })
    }
  }
}
</script>
<style lang="less" scoped>
    .menu-item span{
        display: inline-block;
        overflow: hidden;
        width: 69px;
        text-overflow: ellipsis;
        white-space: nowrap;
        vertical-align: bottom;
        transition: width .2s ease .2s;
    }
    .menu-item i{
        transform: translateX(0px);
        transition: font-size .2s ease, transform .2s ease;
        vertical-align: middle;
        font-size: 16px;
    }
    .collapsed-menu span{
        width: 0px;
        height: 0px;
        transition: width .2s ease;
    }
    .collapsed-menu i{
        transform: translateX(5px);
        transition: font-size .2s ease .2s, transform .2s ease .2s;
        vertical-align: middle;
        font-size: 22px;
    }
</style>
