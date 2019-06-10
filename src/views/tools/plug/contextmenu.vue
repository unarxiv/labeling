<template>
  <div class="contextmenu" :style="offset" v-if="flag">
    <ul>
      <li v-for="(i,k) in menu" :key="k" @click="clickMenu(i)"><Icon :type="i.icon"></Icon> {{i.label}}</li>
    </ul>
  </div>
</template>

<script>
export default {
  data () {
    return {
      menu: [
        {
          label: '编辑形状',
          value: '1',
          icon: 'edit'
        },
        {
          label: '编辑属性',
          value: '2',
          icon: 'edit'
        }
      ],
      flag: false
    }
  },
  props: {
    left: Number,
    top: Number,
    value: Boolean,
    vector: [SVGRectElement, SVGPolylineElement]
  },
  computed: {
    offset () {
      return {
        left: this.left + 'px',
        top: this.top + 'px'
      }
    }
  },
  methods: {
    clickMenu (item) {
      this.$emit('click-menu', item, this.vector)
    },
    hideMenu () {
      this.$emit('input', false)
    },
    addEvent () {
      document.addEventListener('click', this.hideMenu, false)
    },
    removeEvent () {
      document.removeEventListener('click', this.hideMenu)
    }
  },
  watch: {
    value (n) {
      this.flag = n
    },
    flag (n) {
      if (n) {
        this.addEvent()
      } else {
        this.removeEvent()
      }
    }
  },
  activated () {
    this.flag = this.value
  },
  mounted () {
    this.flag = this.value
  },
  destroyed () {
    this.removeEvent()
  }

}
</script>

<style lang="less" scoped>
.contextmenu {
  position: absolute;
  border-radius: 3px;
  background-color: #ffffff;
  box-shadow: 1px 1px 5px rgba(0,0,0,0.2);
  overflow: hidden;

  &>ul{
    &>li{
      padding: 0.3em 0.5em;
      cursor: pointer;

      &:hover{
        background-color: rgba(0,0,0,0.1)
      }
    }
  }
}
</style>
