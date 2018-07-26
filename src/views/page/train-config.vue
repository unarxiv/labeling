<template>
    <div>
      <div style="height:60px;">
        <span>{{ $t("training.choose_type") }}:</span>
        <Select style="width:100px" v-model="type">
          <Option v-for="item in typeList" :value="item.value" :key="item.value">{{ item.label }}</Option>
        </Select>
        <span>{{ $t("training.choose_model") }}:</span>
        <Select @on-change="selectModel" style="width:200px" v-model="selected_model">
          <Option v-for="item in models" :value="item.name" :key="item.id">{{ item.name }}</Option>
        </Select>
      </div>
      <Form ref="configForm" label-position="right" :label-width="160">
          <FormItem :label="v.key" v-for="(v,k) in configList" :key="k" v-if="v.key!='multi_grid'">
              <Input v-model="config[v.key]"></Input>
          </FormItem>
      </Form>
    </div>
</template>
<script>
import { getModels } from '@/libs/service'
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
  watch: {
    type (newVal) {
      this.getConfig()
      this.filterModels()
    }
  },
  data () {
    return {
      config: null,
      configList: [],
      save_loading: false,
      typeList: [
        {
          value: 'detector',
          label: this.$t('training.detection')
        },
        {
          value: 'segmentor',
          label: this.$t('training.segmentation')
        },
        {
          value: 'classifier',
          label: this.$t('training.classification')
        }
      ],
      models: [],
      all_models: [],
      selected_model: '',
      type: 'detector'
    }
  },
  methods: {
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
    getAvailableModels () {
      let self = this
      getModels().then(function (res) {
        self.all_models = res.data
        self.models = res.data.filter(function (each) {
          if (each.task === self.type) {
            return each
          }
        })
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
      this.filterModels()
    },
    selectModel (value) {

    },
    filterModels () {
      let self = this
      this.models = this.all_models.filter(function (each) {
        if (each.task === self.type) {
          return each
        }
      })
    }
  },
  created () {
    this.getAvailableModels()
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
