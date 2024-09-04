# subweb

![Docker Pulls](https://img.shields.io/docker/pulls/slk1133/subweb)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/kirileec/subweb/docker-image.yml)

修改自 [sub-web](https://github.com/CareyWang/sub-web), node和vue版本均升级了一下, 使用vue组合式API和ts

## 一些改动

- 去除了上传配置和短链接
- 后端地址和远程配置均可以通过远程仓库加载json

## Recommended IDE Setup

[VSCode](https://code.visualstudio.com/) + [Vue - Official](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Type Support for `.vue` Imports in TS

TypeScript cannot handle type information for `.vue` imports by default, so we replace the `tsc` CLI with `vue-tsc` for type checking. In editors, we need [Vue - Official](https://marketplace.visualstudio.com/items?itemName=Vue.volar) to make the TypeScript language service aware of `.vue` types.

## Customize configuration

See [Vite Configuration Reference](https://vitejs.dev/config/).

## Project Setup

```sh
npm install
```

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Type-Check, Compile and Minify for Production

```sh
npm run build
```
