<template>
    <div>
      <div style="height:60px;">
        <span>选择类型:</span>
        <Select @on-change="selectType" style="width:100px" v-model="type">
          <Option v-for="item in typeList" :value="item.value" :key="item.value">{{ item.label }}</Option>
        </Select>
        <span>选择模型:</span>
        <Select @on-change="selectType" style="width:200px" v-model="type">
          <Option v-for="item in models" :value="item.name" :key="item.id">{{ item.name }}</Option>
        </Select>
      </div>
      <Form ref="configForm" label-position="right" :label-width="160">
          <FormItem :label="v.key" v-for="(v,k) in configList" :key="k" v-if="v.key!='multi_grid'">
              <Input v-model="config[v.key]"/>
          </FormItem>
      </Form>
    </div>
</template>
<script>
import axios from 'axios'
import util from '../../libs/util'
export default {
  name: 'trainConfig',
  props: {
    list: {
      type: Array,
      default () {
        return []
      }
    }
  },
  data () {
    return {
      config: null,
      configList: [],
      save_loading: false,
      models: [],
      typeList: [
        {
          value: 'detector',
          label: '检测'
        },
        {
          value: 'segmentor',
          label: '分割'
        },
        {
          value: 'classifier',
          label: '分类'
        }
      ],
      type: 'detector'
    }
  },
  watch: {
    type (newVal) {
      this.getModels()
    }
  },
  methods: {
    getModels () {
      let self = this
      axios.get('http://118.89.28.34:9090/static/models.json').then(res => {
        self.models = res.data.filter(function (each) {
          if (each.task === self.type) {
            return each
          }
        })
      })
    },
    getConfig () {
      util.ajax.get('/train/getTrainConfig.do?trainType=' + this.type).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          let data = res.data.data
          this.config = data.config
          this.setConfigList()
        }
      })
    },
    setConfigList () {
      let r = []
      for (let i in this.config) {
        r.push({
          key: i,
          value: this.config[i]
        })
      }
      this.configList = r
    },
    selectType (value) {
      this.type = value
      this.getConfig()
    }
  },
  created () {
    this.getModels()
    this.getConfig()
  }
}
</script>
<style lang="less" scoped>
  .ivu-form {
    overflow: hidden;
    .ivu-form-item {
        float: left;
        width: 32%;
    }
  }

</style>
