// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import axios from 'axios'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import './assets/style.css'
import md5 from 'js-md5';
Vue.prototype.$md5 = md5;
Vue.use(ElementUI);
Vue.prototype.$http= axios;
Vue.config.productionTip = false;

import { codemirror } from 'vue-codemirror'
import 'codemirror/lib/codemirror.css'
Vue.use(codemirror);

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})
