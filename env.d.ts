/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly SUB_PROJECT: string
  readonly SUB_SUBCONVERTER_REMOTE_CONFIG: string
  readonly SUB_SUBCONVERTER_DOC_ADVANCED: string
  readonly SUB_BACKEND_RELEASE: string
  readonly SUB_SUBCONVERTER_DEFAULT_BACKEND: string
  readonly SUB_MYURLS_API: string
  readonly SUB_CONFIG_UPLOAD_API: string
  readonly SUB_BOT_LINK: string
  readonly SUB_USE_STORAGE: string
  readonly SUB_CACHE_TTL: string
  readonly SUB_LOAD_REMOTE: string
  readonly SUB_REMOTE_JSON: string

  // more env variables...
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
