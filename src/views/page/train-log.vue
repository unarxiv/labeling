<template>
    <div>
        <Card>
            <p slot="title" style="overflow: visible">
                <Row>
                    <Col span="20"><Icon type="ios-keypad"></Icon> {{groupName}} - {{taskName}} 训练日志</Col>
                    <Col span="4" align="right"></Col>
                </Row>
            </p>
             <Collapse v-model="plane">
              <Panel name="1">
                  Config
                  <div slot="content">
                    <Row :label="v.key" v-for="(v,k) in configList" :key="k" class-name="config-list">
                      <Col span="8">{{v.key}}</Col>
                      <Col span="8">{{v.value}}</Col>
                    </Row>
                  </div>
              </Panel>
              <Panel name="2">
                  Full Log
                  <div slot="content">
                     <Tabs :animated="false" @on-click="tabChange">
                        <TabPane label="PLAIN" name="PLAIN">{{data}}</TabPane>
                        <TabPane label="TABLE" name="TABLE"><Table :columns="columns" :data="data"></Table></TabPane>
                        <TabPane label="CHART" name="CHART">
                          <Row>
                            <Col span="8">
                              <p v-for="(each, index) in headers" :key="index" style="padding-left:10px">
                                <Button type="text" @click="changeChartData(each.text)" :disabled="chartKey===each.text">{{ each.text }}</Button>
                              </p>
                            </Col>
                            <Col span="16">
                              <lineChart
                                :chartData="chartData"
                                :options="{responsive: false, maintainAspectRatio: false}"
                              >
                              </lineChart>
                            </Col>
                          </Row>
                        </TabPane>
                     </Tabs>
                  </div>
              </Panel>
              <Panel name="3">
                  Download
                  <div slot="content">

                  </div>
              </Panel>
          </Collapse>
        </Card>
    </div>
</template>
<script>
import expandRow from './data-detail.vue'
import util from '../../libs/util'
import lineChart from '../../components/lineChart'
export default {
  components: {
    expandRow,
    lineChart
  },
  data () {
    return {
      plane: '',
      config: null,
      configList: [],
      columns: [
        {
          title: 'MIOU',
          key: 'MIOU'
        },
        {
          title: 'avg_train_loss',
          key: 'avg_train_loss'
        },
        {
          title: 'avg_validation_loss',
          key: 'avg_validation_loss'
        },
        {
          title: 'global_step',
          key: 'global_step'
        }
      ],
      data: [

      ],
      chartData: [],
      chartKey: ''
    }
  },
  computed: {
    headers () {
      if (this.data[0]) {
        let keys = Object.keys(this.data[0])
        let heads = []
        for (let i in keys) {
          heads.push(
            {
              text: keys[i],
              value: keys[i],
              align: 'right',
              sortable: true
            }
          )
        }
        return heads
      }
    }
  },
  methods: {
    getConfig () {
      util.ajax.get('/train/getTrainConfig.do').then(res => {
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
    fillData (name) {
      let data = []
      for (let i in this.data) {
        data.push(this.data[i][name])
      }
      this.chartData = {
        datasets: [
          {
            label: name,
            backgroundColor: '#2196F3',
            data: data
          }
        ]
      }
    },
    changeType (selectedType) {
      this.type = selectedType
      if (selectedType === 'chart') {
        this.fillData(this.headers[0].value)
      }
    },
    changeChartData (key) {
      this.fillData(key)
      this.chartKey = key
    },
    tabChange (name) {
      if (name === 'CHART' && this.chartKey === '') {
        this.changeChartData(this.headers[0].text)
      }
    },
    getData () {
      util.ajax.get('/train/getTrainLog.do?idTrainInfo=' + this.id).then(res => {
        if (!res.data.status) {
          this.$Message.error(res.data.errormsg)
        } else {
          let data = res.data.data
          let trainLog = data.trainLog
          this.config = data.config
          this.data = trainLog.results
          this.setConfigList()
        }
      })
    }
  },
  created () {
    this.id = this.$route.params.id
    this.groupName = this.$route.query.groupName
    this.taskName = this.$route.query.taskName
  },
  mounted () {
    this.getData()
  }
}
</script>
<style lang="less">
.config-list{
  border-bottom: 1px dotted rgba(0,0,0,.05);
  line-height: 2em;
}
</style>
