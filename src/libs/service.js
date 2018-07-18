import axios from 'axios'

function _inferenceCall (endpoint, image) {
  return new Promise((resolve, reject) => {
    let payload = new FormData()
    payload.append('ufile', image)
    axios.post(endpoint, payload).then(function (res) {
      resolve(res)
    })
  })
}

function detect (modelName, image) {
  let host = 'http://127.0.0.1:9090/'
  return _inferenceCall(host + 'detector/detect?model_name=' + modelName, image)
}

export {
  detect
}
