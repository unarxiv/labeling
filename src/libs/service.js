import axios from 'axios'

let host = 'http://134.175.1.246/'

function _inferenceCall (endpoint, image) {
  return new Promise((resolve, reject) => {
    let payload = new FormData()
    payload.append('ufile', image)
    axios.post(endpoint, payload).then(function (res) {
      resolve(res)
    })
  })
}

function _getRequest (endpoint) {
  return new Promise((resolve, reject) => {
    axios.get(endpoint).then(function (res) {
      resolve(res)
    }).catch(function (err) {
      reject(err)
    })
  })
}

function getModelFile (modelFileName) {
  return _getRequest(host + 'detector/get_model?model_id=' + modelFileName)
}

function detect (modelName, image) {
  return _inferenceCall(host + 'detector/detect?model_name=' + modelName, image)
}

function getLog (logfilename) {
  console.log('getting remote log')
  console.log('static/' + logfilename + '/log.json')
  return _getRequest(host + 'static/' + logfilename + '/log.json')
}

function getInferenceEndpoint (modelName) {
  return host + 'detector/detect?model_name=' + modelName
}

export {
  detect,
  getLog,
  getModelFile,
  getInferenceEndpoint
}
