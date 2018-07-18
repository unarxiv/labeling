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
                    <Button type="ghost" shape="circle" icon="loop" @click="refreshLog()"></Button>
                     <Tabs :animated="false" @on-click="tabChange">
                        <TabPane label="PLAIN" name="PLAIN">{{ trainLog }}</TabPane>
                        <TabPane label="TABLE" name="TABLE"><Table :columns="tableHeaders" :data="trainLog"></Table></TabPane>
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
                    <Button type="ghost" icon="loop" @click="request_model()">Request</Button>
                    <a :href=download_url>Download Now</a>
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
import { getLog, getModelFile } from '@/libs/service'
export default {
  components: {
    expandRow,
    lineChart
  },
  data () {
    return {
      plane: '',
      config: null,
      download_url: '',
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
      trainLog: [],
      chartData: [],
      chartKey: ''
    }
  },
  computed: {
    headers () {
      if (this.trainLog[0]) {
        let keys = Object.keys(this.trainLog[0])
        let heads = []
        for (let i in keys) {
          heads.push({
            text: keys[i],
            value: keys[i],
            align: 'right',
            sortable: true
          })
        }
        return heads
      }
    },
    tableHeaders () {
      if (this.trainLog[0]) {
        let keys = Object.keys(this.trainLog[0])
        let heads = []
        for (let i in keys) {
          heads.push({
            title: keys[i],
            key: keys[i],
            align: 'right',
            sortable: true
          })
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
      for (let i in this.trainLog) {
        data.push(this.trainLog[i][name])
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
    refreshLog () {
      this.getData()
    },
    getData () {
      /*
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
      */
      let self = this
      getLog(this.$route.query.modelId).then(function (res) {
        self.trainLog = res.data
        console.log(self.trainLog)
      })
      //  getModelFile(this.$route.query.modelId).then(function (res) {
      //    self.download_url = res.data.url
      //  })
    },
    request_model () {

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
.config-list {
  border-bottom: 1px dotted rgba(0, 0, 0, 0.05);
  line-height: 2em;
}
</style>
