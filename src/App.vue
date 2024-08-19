<template>
  <div>
    <el-row style="margin-top: 10px">
      <el-col>
        <el-card>
          <template v-slot:header>
            <div>
              订阅转换器
              <svg
                t="1583490608116"
                class="icon"
                viewBox="0 0 1024 1024"
                version="1.1"
                xmlns="http://www.w3.org/2000/svg"
                p-id="1255"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                width="20"
                height="20"
                @click="goToProject"
              >
                <path
                  d="M511.542857 14.057143C228.914286 13.942857 0 242.742857 0 525.142857 0 748.457143 143.2 938.285714 342.628571 1008c26.857143 6.742857 22.742857-12.342857 22.742858-25.371429v-88.571428c-155.085714 18.171429-161.371429-84.457143-171.771429-101.6C172.571429 756.571429 122.857143 747.428571 137.714286 730.285714c35.314286-18.171429 71.314286 4.571429 113.028571 66.171429 30.171429 44.685714 89.028571 37.142857 118.857143 29.714286 6.514286-26.857143 20.457143-50.857143 39.657143-69.485715-160.685714-28.8-227.657143-126.857143-227.657143-243.428571 0-56.571429 18.628571-108.571429 55.2-150.514286-23.314286-69.142857 2.171429-128.342857 5.6-137.142857 66.4-5.942857 135.428571 47.542857 140.8 51.771429 37.714286-10.171429 80.8-15.542857 129.028571-15.542858 48.457143 0 91.657143 5.6 129.714286 15.885715 12.914286-9.828571 76.914286-55.771429 138.628572-50.171429 3.314286 8.8 28.228571 66.628571 6.285714 134.857143 37.028571 42.057143 55.885714 94.514286 55.885714 151.2 0 116.8-67.428571 214.971429-228.571428 243.314286a145.714286 145.714286 0 0 1 43.542857 104v128.571428c0.914286 10.285714 0 20.457143 17.142857 20.457143 202.4-68.228571 348.114286-259.428571 348.114286-484.685714 0-282.514286-229.028571-511.2-511.428572-511.2z"
                  p-id="1256"
                ></path>
              </svg>

              <div style="display: inline-block; position: absolute; right: 20px">
                {{ backendVersion }}
              </div>
            </div>
          </template>
          <el-container>
            <el-form :model="form" label-width="140px" label-position="left" style="width: 100%">
              <el-form-item label="模式设置:">
                <el-radio v-model="advanced" label="1">基础模式</el-radio>
                <el-radio v-model="advanced" label="2">进阶模式</el-radio>
              </el-form-item>
              <el-form-item label="订阅链接:">
                <el-input
                  v-model="form.sourceSubUrl"
                  type="textarea"
                  :rows="3"
                  placeholder="支持订阅或ss/ssr/vmess链接，多个链接每行一个或用 | 分隔"
                  @blur="saveSubUrl"
                />
              </el-form-item>
              <el-form-item label="客户端:">
                <el-select v-model="form.clientType" style="width: 100%">
                  <el-option
                    v-for="(v, k) in options.clientTypes"
                    :key="k"
                    :label="k"
                    :value="v"
                  ></el-option>
                </el-select>
              </el-form-item>

              <div v-if="advanced === '2'">
                <el-form-item label="后端地址:">
                  <el-autocomplete
                    style="width: 100%"
                    v-model="form.customBackend"
                    :fetch-suggestions="backendSearch"
                    placeholder="自建后端。例：http://127.0.0.1:25500/sub?"
                  >
                    <template v-slot:append>
                      <el-button @click="gotoGayhub" :icon="Link">前往项目仓库</el-button>
                    </template>
                  </el-autocomplete>
                </el-form-item>
                <el-form-item label="远程配置:">
                  <el-select
                    v-model="form.remoteConfig"
                    allow-create
                    filterable
                    placeholder="请选择"
                    style="width: 100%"
                  >
                    <el-option-group
                      v-for="group in options.remoteConfig"
                      :key="group.label"
                      :label="group.label"
                    >
                      <el-option
                        v-for="item in group.options"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value"
                      ></el-option>
                    </el-option-group>
                    <template v-slot:append>
                      <el-button @click="gotoRemoteConfig" :icon="Link">配置示例</el-button>
                    </template>
                  </el-select>
                </el-form-item>
                <el-form-item label="包含:">
                  <el-input
                    v-model="form.includeRemarks"
                    placeholder="节点名包含的关键字，支持正则"
                  />
                </el-form-item>
                <el-form-item label="排除:">
                  <el-input
                    v-model="form.excludeRemarks"
                    placeholder="排除节点名的关键字，支持正则"
                  />
                </el-form-item>
                <el-form-item label="文件名:">
                  <el-input v-model="form.filename" placeholder="返回的订阅文件名" />
                </el-form-item>

                <el-form-item v-for="(param, i) in customParams" :key="i">
                  <template v-slot:label>
                    <el-input v-model="param.name" placeholder="自定义参数名">
                      <template v-slot:suffix>
                        <div style="width: 10px">:</div>
                      </template>
                    </el-input>
                  </template>
                  <el-input v-model="param.value" placeholder="自定义参数内容">
                    <template v-slot:suffix>
                      <el-button
                        type="text"
                        :icon="Delete"
                        style="margin-right: 5px"
                        @click="customParams.splice(i, 1)"
                      />
                    </template>
                  </el-input>
                </el-form-item>

                <el-form-item label-width="0px">
                  <el-row>
                    <el-checkbox
                      v-model="form.nodeList"
                      label="输出为节点列表"
                      border
                    ></el-checkbox>

                    <el-popover placement="bottom" v-model="form.extraset">
                      <el-row>
                        <el-checkbox v-model="form.emoji" label="Emoji"></el-checkbox>
                      </el-row>
                      <el-row>
                        <el-checkbox v-model="form.scv" label="跳过证书验证"></el-checkbox>
                      </el-row>
                      <el-row>
                        <el-checkbox
                          v-model="form.udp"
                          @change="needUdp = true"
                          label="启用 UDP"
                        ></el-checkbox>
                      </el-row>
                      <el-row>
                        <el-checkbox v-model="form.appendType" label="节点类型"></el-checkbox>
                      </el-row>
                      <el-row>
                        <el-checkbox v-model="form.sort" label="排序节点"></el-checkbox>
                      </el-row>
                      <el-row>
                        <el-checkbox v-model="form.fdn" label="过滤非法节点"></el-checkbox>
                      </el-row>
                      <el-row>
                        <el-checkbox v-model="form.expand" label="规则展开"></el-checkbox>
                      </el-row>
                      <template v-slot:reference>
                        <el-button style="margin-left: 10px">更多选项</el-button>
                      </template>
                    </el-popover>

                    <el-popover placement="bottom" style="margin-left: 10px">
                      <el-row>
                        <el-checkbox v-model="form.tpl.surge.doh" label="Surge.DoH"></el-checkbox>
                      </el-row>
                      <el-row>
                        <el-checkbox v-model="form.tpl.clash.doh" label="Clash.DoH"></el-checkbox>
                      </el-row>
                      <el-row>
                        <el-checkbox v-model="form.insert" label="网易云"></el-checkbox>
                      </el-row>
                      <template v-slot:reference>
                        <el-button>定制功能</el-button>
                      </template>
                    </el-popover>

                    <el-popover placement="top-end" title="添加自定义转换参数" trigger="hover">
                      <el-link
                        type="primary"
                        :href="subDocAdvanced"
                        target="_blank"
                        :icon="InfoFilled"
                        >参考文档</el-link
                      >
                      <template v-slot:reference>
                        <el-button @click="addCustomParam" style="margin-left: 10px">
                          <el-icon>
                            <Plus />
                          </el-icon>
                        </el-button>
                      </template>
                    </el-popover>
                  </el-row>
                </el-form-item>
              </div>

              <div style="margin-top: 50px"></div>

              <el-divider content-position="center">
                <el-icon>
                  <MagicStick />
                </el-icon>
              </el-divider>

              <el-form-item label="定制订阅:">
                <el-input class="copy-content" disabled v-model="customSubUrl">
                  <template v-slot:append>
                    <el-button @click="copy(customSubUrl)" ref="copy-btn" :icon="CopyDocument">{{
                      copied ? '已复制' : '复制'
                    }}</el-button>
                  </template>
                </el-input>
              </el-form-item>
              <!-- <el-form-item label="订阅短链:">
                <el-input class="copy-content" disabled v-model="curtomShortSubUrl">
                  <template v-slot:append>
                    <el-button
                      @click="copy(curtomShortSubUrl)"
                      ref="copy-btn"
                      :icon="CopyDocument"
                      >{{ copied ? '已复制' : '复制' }}</el-button
                    >
                  </template>
                </el-input>
              </el-form-item> -->

              <el-form-item label-width="0px" style="margin-top: 40px; text-align: center">
                <el-button
                  style="width: 140px"
                  type="danger"
                  @click="makeUrl"
                  :disabled="form.sourceSubUrl.length === 0"
                  >生成订阅链接</el-button
                >
                <el-button
                  style="width: 140px"
                  type="danger"
                  @click="makeShortUrl"
                  :loading="loading"
                  :disabled="customSubUrl.length === 0"
                  >生成短链接</el-button
                >
                <el-button
                  style="width: 140px"
                  type="primary"
                  @click="surgeInstall"
                  :icon="Connection"
                  >一键导入Surge</el-button
                >

                <!-- <el-button
                  style="width: 140px"
                  type="primary"
                  @click="dialogUploadConfigVisible = true"
                  :icon="Upload"
                  :loading="loading"
                  >上传配置</el-button
                > -->
                <el-button
                  style="width: 140px"
                  type="primary"
                  @click="clashInstall"
                  :icon="Connection"
                  >一键导入 Clash</el-button
                >
                <el-button
                  style="width: 290px"
                  type="primary"
                  @click="dialogLoadConfigVisible = true"
                  :icon="CopyDocument"
                  :loading="loading"
                  >从订阅地址解析</el-button
                >
              </el-form-item>
            </el-form>
          </el-container>
        </el-card>
      </el-col>
    </el-row>

    <el-dialog
      v-model="dialogUploadConfigVisible"
      :show-close="false"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      width="700px"
    >
      <template v-slot:header>
        <div>
          远程配置上传
          <el-popover trigger="hover" placement="right" style="margin-left: 10px">
            <el-link type="primary" :href="sampleConfig" target="_blank" :icon="InfoFilled"
              >参考配置</el-link
            >
            <template v-slot:reference>
              <el-icon>
                <QuestionFilled />
              </el-icon>
            </template>
          </el-popover>
        </div>
      </template>
      <el-form label-position="left">
        <el-form-item prop="uploadConfig">
          <el-input
            v-model="uploadConfig"
            type="textarea"
            :autosize="{ minRows: 15, maxRows: 30 }"
            maxlength="10000"
            show-word-limit
          ></el-input>
        </el-form-item>
      </el-form>
      <template v-slot:footer>
        <div class="dialog-footer">
          <el-button @click="cancelDialogUpload">取 消</el-button>
          <el-button
            type="primary"
            @click="confirmUploadConfig"
            :disabled="uploadConfig.length === 0"
            >确 定</el-button
          >
        </div>
      </template>
    </el-dialog>

    <el-dialog
      v-model="dialogLoadConfigVisible"
      :show-close="false"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      width="700px"
    >
      <template v-slot:header>
        <div>解析已转换链接</div>
      </template>
      <el-form label-position="left" :inline="true">
        <el-form-item prop="uploadConfig" label="订阅链接：" label-width="85px">
          <el-input v-model="loadConfig" style="width: 565px"></el-input>
        </el-form-item>
      </el-form>
      <template v-slot:footer>
        <div class="dialog-footer">
          <el-button @click="(uploadConfig = ''), (dialogLoadConfigVisible = false)"
            >取 消</el-button
          >
          <el-button type="primary" @click="confirmLoadConfig" :disabled="loadConfig.length === 0"
            >确 定</el-button
          >
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { ElMessage, ElNotification } from 'element-plus'
import { useClipboard } from '@vueuse/core'
const project = import.meta.env.SUB_PROJECT
const remoteConfigSample = import.meta.env.SUB_SUBCONVERTER_REMOTE_CONFIG
const asubDocAdvanced = import.meta.env.SUB_SUBCONVERTER_DOC_ADVANCED
const gayhubRelease = import.meta.env.SUB_BACKEND_RELEASE
const defaultBackend = import.meta.env.SUB_SUBCONVERTER_DEFAULT_BACKEND + '/sub?'
const shortUrlBackend = import.meta.env.SUB_MYURLS_API
const configUploadBackend = import.meta.env.SUB_CONFIG_UPLOAD_API
const tgBotLink = import.meta.env.SUB_BOT_LINK
const useStorage = import.meta.env.SUB_USE_STORAGE === 'true'
const ifLoadRemote = import.meta.env.SUB_LOAD_REMOTE === 'true'
const remoteJson = import.meta.env.SUB_REMOTE_JSON

const backendVersion = ref('')
const advanced = ref('2')
const isPC = ref(true)
const options = ref({
  clientTypes: {
    singbox: 'singbox',
    Clash: 'clash',
    ClashR: 'clashr',
    Surge: 'surge&ver=4',
    Surge3: 'surge&ver=3',
    QuantumultX: 'quanx',
    Surfboard: 'surfboard',
    V2Ray: 'v2ray',
    Trojan: 'trojan',
    Mellow: 'mellow',
    Loon: 'loon',
    ss: 'ss',
    ssd: 'ssd',
    sssub: 'sssub',
    ssr: 'ssr'
  },
  backendOptions: [{ value: defaultBackend }, { value: 'https://api.flowercloud.yt/sub?' }],
  remoteConfig: [
    {
      label: '',
      options: [
        {
          label: '',
          value: ''
        }
      ]
    }
  ]
})

const form = ref({
  sourceSubUrl: '',
  clientType: '',
  customBackend: '',
  remoteConfig: 'Acl4SSR',
  excludeRemarks: '',
  includeRemarks: '',
  filename: '',
  emoji: true,
  nodeList: false,
  extraset: false,
  sort: false,
  udp: true,
  tfo: false,
  scv: true,
  fdn: false,
  expand: true,
  appendType: true,
  insert: false, // 是否插入默认订阅的节点，对应配置项 insert_url
  new_name: true, // 是否使用 Clash 新字段

  // tpl 定制功能
  tpl: {
    surge: {
      doh: false // dns 查询是否使用 DoH
    },
    clash: {
      doh: false
    }
  }
})

const customParams = ref<{ name: string; value: string }[]>([])
const loading = ref(false)
const customSubUrl = ref('')
const curtomShortSubUrl = ref('')
const dialogUploadConfigVisible = ref(false)
const loadConfig = ref('')
const dialogLoadConfigVisible = ref(false)
const uploadConfig = ref('')
const uploadPassword = ref('')

const myBot = ref(tgBotLink)
const sampleConfig = ref(remoteConfigSample)
const subDocAdvanced = ref(asubDocAdvanced)
const needUdp = ref(true)

const { copied, copy } = useClipboard()

import { onMounted, h } from 'vue'
import {
  Connection,
  CopyDocument,
  Delete,
  InfoFilled,
  Link,
  MagicStick,
  Plus,
  QuestionFilled,
  Upload
} from '@element-plus/icons-vue'

function cancelDialogUpload() {
  uploadConfig.value = ''
  dialogUploadConfigVisible.value = false
}

onMounted(() => {
  document.title = '订阅转换器'

  form.value.clientType = 'singbox'
  if (!useStorage) {
    form.value.sourceSubUrl = getLocalStorageItem('sourceSubUrl')
  }
  getBackendVersion()
  loadRemoteConfigs()
  setTimeout(() => {
    notify()
  }, 1000)
})

function loadRemoteConfigs() {
  if (ifLoadRemote) {
    fetch(remoteJson).then(async (res) => {
      let data = await res.json()
      options.value.remoteConfig = data
    })
  }
}

function onCopy() {
  ElMessage.info('Copied')
}
function goToProject() {
  window.open(project)
}
function gotoGayhub() {
  window.open(gayhubRelease)
}
function gotoRemoteConfig() {
  window.open(remoteConfigSample)
}
function clashInstall() {
  if (customSubUrl.value === '') {
    ElMessage.error('请先填写必填项，生成订阅链接')
    return false
  }

  const url = 'clash://install-config?url='
  window.open(
    url +
      encodeURIComponent(
        curtomShortSubUrl.value !== '' ? curtomShortSubUrl.value : customSubUrl.value
      )
  )
}
function surgeInstall() {
  if (customSubUrl.value === '') {
    ElMessage.error('请先填写必填项，生成订阅链接')
    return false
  }

  const url = 'surge://install-config?url='
  window.open(url + customSubUrl.value)
}
function addCustomParam() {
  customParams.value.push({
    name: '',
    value: ''
  })
}

function makeUrl() {
  if (form.value.sourceSubUrl === '' || form.value.clientType === '') {
    ElMessage.error('订阅链接与客户端为必填项')
    return false
  }

  let backend = form.value.customBackend === '' ? defaultBackend : form.value.customBackend

  let sourceSub = form.value.sourceSubUrl
  sourceSub = sourceSub.replace(/(\n|\r|\n\r)/g, '|')

  customSubUrl.value =
    backend +
    'target=' +
    form.value.clientType +
    '&url=' +
    encodeURIComponent(sourceSub) +
    '&insert=' +
    form.value.insert

  if (advanced.value === '2') {
    if (form.value.remoteConfig) {
      customSubUrl.value += '&config=' + encodeURIComponent(form.value.remoteConfig)
    }
    if (form.value.excludeRemarks) {
      customSubUrl.value += '&exclude=' + encodeURIComponent(form.value.excludeRemarks)
    }
    if (form.value.includeRemarks) {
      customSubUrl.value += '&include=' + encodeURIComponent(form.value.includeRemarks)
    }
    if (form.value.filename) {
      customSubUrl.value += '&filename=' + encodeURIComponent(form.value.filename)
    }
    if (form.value.appendType) {
      customSubUrl.value += '&append_type=' + form.value.appendType.toString()
    }

    customSubUrl.value +=
      '&emoji=' +
      form.value.emoji.toString() +
      '&list=' +
      form.value.nodeList.toString() +
      '&tfo=' +
      form.value.tfo.toString() +
      '&scv=' +
      form.value.scv.toString() +
      '&fdn=' +
      form.value.fdn.toString() +
      '&expand=' +
      form.value.expand.toString() +
      '&sort=' +
      form.value.sort.toString()

    if (needUdp.value) {
      customSubUrl.value += '&udp=' + form.value.udp.toString()
    }

    if (form.value.tpl.surge.doh === true) {
      customSubUrl.value += '&surge.doh=true'
    }

    if (form.value.clientType === 'clash') {
      if (form.value.tpl.clash.doh === true) {
        customSubUrl.value += '&clash.doh=true'
      }

      customSubUrl.value += '&new_name=' + form.value.new_name.toString()
    }

    customParams.value
      .filter((param) => param.name && param.value)
      .forEach((param) => {
        customSubUrl.value += `&${encodeURIComponent(param.name)}=${encodeURIComponent(param.value)}`
      })
  }

  copy(customSubUrl.value)
  ElMessage.success('定制订阅已复制到剪贴板')
}
function getFormData(object: any) {
  const formData = new FormData()
  Object.keys(object).forEach((key) => formData.append(key, object[key]))
  return formData
}
function makeShortUrl() {
  if (customSubUrl.value === '') {
    ElMessage.warning('请先生成订阅链接，再获取对应短链接')
    return false
  }

  loading.value = true

  let data = new FormData()
  data.append('longUrl', btoa(customSubUrl.value))

  fetch(shortUrlBackend, {
    headers: {
      'Content-Type': 'application/form-data; charset=utf-8'
    },
    body: getFormData(data)
  })
    .then(async (res) => {
      let data = await res.json()
      if (data.Code === 1 && data.ShortUrl !== '') {
        curtomShortSubUrl.value = data.ShortUrl
        copy(data.ShortUrl)
        ElMessage.success('短链接已复制到剪贴板')
      } else {
        ElMessage.error('短链接获取失败：' + data.Message)
      }
    })
    .finally(() => {
      loading.value = false
    })
}
function notify() {
  ElNotification({
    title: '隐私提示',
    message: h(
      'i',
      { style: 'color: teal' },
      '各种订阅链接（短链接服务除外）生成纯前端实现，无隐私问题。默认提供后端转换服务，隐私担忧者请自行搭建后端服务。'
    ),
    type: 'warning'
  })
}

function confirmUploadConfig() {
  if (uploadConfig.value === '') {
    ElMessage.warning('远程配置不能为空')
    //this.$message.warning("远程配置不能为空");
    return false
  }

  loading.value = true

  let body1 = {
    content: uploadConfig.value
  }
  fetch(configUploadBackend, {
    method: 'POST',
    body: JSON.stringify(body1)
  })
    .then(async (res) => {
      let data = await res.json()
      if (data.code === 0 && data.data.url !== '') {
        //this.$message.success(
        //"远程配置上传成功，配置链接已复制到剪贴板，有效期三个月望知悉"
        //)
        ElMessage.success('远程配置上传成功，配置链接已复制到剪贴板，有效期三个月望知悉')

        // 自动填充至『表单-远程配置』
        form.value.remoteConfig = data.data.url
        copy(form.value.remoteConfig)
        dialogUploadConfigVisible.value = false
      } else {
        ElMessage.error('远程配置上传失败: ' + data.msg)
        //this.$message.error("远程配置上传失败: " + res.data.msg);
      }
    })
    .catch((err) => {
      ElMessage.error('远程配置上传失败: ' + err)
      //this.$message.error("远程配置上传失败");
    })
    .finally(() => {
      loading.value = false
    })
}
/**
 * Asynchronously analyzes the URL.
 *
 * @return {Promise<string>} The result of the analysis.
 */
async function analyzeUrl(): Promise<string> {
  // Check if `loadConfig` includes "target"
  if (loadConfig.value.includes('target')) {
    // If it does, return `loadConfig`
    return loadConfig.value
  } else {
    // Otherwise, set `loading` to true
    loading.value = true
    try {
      // Fetch the data from `loadConfig` using GET method and follow redirects
      let response = await fetch(loadConfig.value, {
        method: 'GET',
        redirect: 'follow'
      })
      // Return the URL from the response
      return response.url
    } catch (e) {
      ElMessage.error('解析短链接失败，请检查短链接服务端是否配置跨域：' + e)
      // If an error occurs, display an error message with the error details
      //this.$message.error('解析短链接失败，请检查短链接服务端是否配置跨域：' + e)
    } finally {
      // Set `loading` to false
      loading.value = false
    }
  }
  return ''
}
function /**
 * Confirm and load the configuration.
 *
 * @return {boolean} Returns false if the 'loadConfig' is empty, otherwise returns true.
 */
confirmLoadConfig() {
  // Check if 'loadConfig' is empty
  if (loadConfig.value.trim() === '') {
    // Display error message if 'loadConfig' is empty
    //this.$message.error("订阅链接不能为空");
    ElMessage.error('订阅链接不能为空')
    return false
  }

  // Async function to handle the configuration loading
  ;(async () => {
    try {
      // Analyze the URL and extract its components
      const url = new URL(await analyzeUrl())

      // Set the custom backend URL
      form.value.customBackend = url.origin + url.pathname + '?'

      // Parse the URL parameters
      const params = new URLSearchParams(url.search)

      // Record parameters have been read
      const getParam = params.get.bind(params)
      const excludeParams = new Set()
      params.get = (key) => {
        excludeParams.add(key)
        return getParam(key)
      }

      // Get the 'target' parameter
      const target = params.get('target')!!

      // Set the client type based on the 'target' parameter
      if (target === 'surge') {
        const ver = params.get('ver') || '4'
        form.value.clientType = target + '&ver=' + ver
      } else {
        form.value.clientType = target
      }

      // Set other form properties based on the URL parameters
      form.value.sourceSubUrl = params.get('url')!!.replace(/\|/g, '\n')
      form.value.insert = params.get('insert') === 'true'
      form.value.remoteConfig = params.get('config')!!
      form.value.excludeRemarks = params.get('exclude')!!
      form.value.includeRemarks = params.get('include')!!
      form.value.filename = params.get('filename')!!
      form.value.appendType = params.get('append_type') === 'true'
      form.value.emoji = params.get('emoji') === 'true'
      form.value.nodeList = params.get('list') === 'true'
      form.value.tfo = params.get('tfo') === 'true'
      form.value.scv = params.get('scv') === 'true'
      form.value.fdn = params.get('fdn') === 'true'
      form.value.sort = params.get('sort') === 'true'
      form.value.udp = params.get('udp') === 'true'
      form.value.expand = params.get('expand') === 'true'
      form.value.tpl.surge.doh = params.get('surge.doh') === 'true'
      form.value.tpl.clash.doh = params.get('clash.doh') === 'true'
      form.value.new_name = params.get('new_name') === 'true'

      // Filter custom parameters
      customParams.value = Array.from(params.entries())
        .filter((e: any[]) => !excludeParams.has(e[0]))
        .map((e: any[]) => ({ name: e[0], value: e[1] }))

      // Hide the configuration dialog
      dialogLoadConfigVisible.value = false

      // Display success message
      ElMessage.success('长/短链接已成功解析为订阅信息')
    } catch (error) {
      // Display error message if URL is not valid
      ElMessage.error('请输入正确的订阅地址!')
    }
  })()
}

function backendSearch(queryString: string, cb: (arg0: { value: string }[]) => void) {
  let backends = options.value.backendOptions

  let results = queryString ? backends.filter(createFilter(queryString)) : backends

  // 调用 callback 返回建议列表的数据
  cb(results)
}
function createFilter(queryString: string) {
  return (candidate: { value: string }) => {
    return candidate.value.toLowerCase().indexOf(queryString.toLowerCase()) === 0
  }
}
function getLocalStorageItem(itemKey: string) {
  const now = +new Date()
  let ls = localStorage.getItem(itemKey)

  let itemValue = ''
  if (ls !== null) {
    let data = JSON.parse(ls)
    if (data.expire > now) {
      itemValue = data.value
    } else {
      localStorage.removeItem(itemKey)
    }
  }

  return itemValue
}
function setLocalStorageItem(itemKey: string, itemValue: any) {
  const ttl = import.meta.env.SUB_CACHE_TTL
  const now = +new Date()
  let t = parseInt(ttl)
  let data = {
    setTime: now,
    ttl: t,
    expire: now + t * 1000,
    value: itemValue
  }
  localStorage.setItem(itemKey, JSON.stringify(data))
}
function saveSubUrl() {
  if (form.value.sourceSubUrl !== '') {
    setLocalStorageItem('sourceSubUrl', form.value.sourceSubUrl)
  }
}
function getBackendVersion() {
  fetch(defaultBackend.substring(0, defaultBackend.length - 5) + '/version', {
    method: 'GET'
  }).then(async (res) => {
    let data = await res.text()
    backendVersion.value = data.replace(/backend\n$/gm, '')
    backendVersion.value = backendVersion.value.replace('subconverter', '')
  })
}
</script>

<style scoped>
.icon {
  cursor: pointer;
  margin-left: 20px;
}
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
