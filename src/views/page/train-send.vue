<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> {{ $t("training.model_training") }} > {{groupName}} - {{taskName}} </Col>
                    <Col span="4" align="right"></Col>
                </Row>
            </p>
            <div>
              <Form ref="configForm" label-position="right" :label-width="160">
                  <trainConfig :list="[]" ref="trainConfig"></trainConfig>
                  <FormItem>
                    <Button type="primary" :loading="save_loading" @click="send">{{ $t("general.submit") }}</Button>
                  </FormItem>
              </Form>
            </div>
        </Card>
    </div>
</template>
<script>
import util from '../../libs/util'
import trainConfig from './train-config'
export default {
  components: {
    trainConfig
  },
  data () {
    return {
      plane: '',
      config: null,
      configList: [],
      save_loading: false
    }
  },
  methods: {
    send () {
      let selectedModel = this.$refs.selected_model
      let config = this.$refs.trainConfig.config
      let type = this.$refs.trainConfig.type
      this.save_loading = true
      util.ajax.post('/train/reStartTrain.do', {
        config: config,
        idTrainInfo: this.id,
        trainType: type,
        modelId: selectedModel
      }).then(res => {
        this.save_loading = false
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          let data = res.data.data
          this.$router.push({
            name: 'trainlog',
            params: {
              id: data.idTrainInfo
            },
            query: {
              groupName: this.groupName,
              taskName: this.taskName
            }
          })
        }
      })
    }
  },
  created () {
    this.id = this.$route.params.id
    this.groupName = this.$route.query.groupName
    this.taskName = this.$route.query.taskName
  }
}
</script>
