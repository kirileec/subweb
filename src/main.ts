import './assets/main.css'

import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue'
import VueQrcode from '@chenfengyuan/vue-qrcode';

createApp(App).use(ElementPlus, { size: 'default', zIndex: 3000 }).component(VueQrcode.name!!,VueQrcode).mount('#app')
