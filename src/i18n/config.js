import i18n from '@/i18n'
import map from '@/i18n/map'

function setLang (lang) {
  localStorage.setItem('lang', lang)
  i18n.locale = map[lang]
}

function loadDefautlLang (lang) {
  i18n.locale = map[localStorage.getItem('lang')]
}

function getLang () {
  return localStorage.getItem('lang')
}

export {
  getLang,
  loadDefautlLang,
  setLang
}