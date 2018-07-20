import i18n from '@/i18n'
import map from '@/i18n/map'

function setLang (lang) {
    i18n.locale = map[lang]
}

export {
    setLang
}