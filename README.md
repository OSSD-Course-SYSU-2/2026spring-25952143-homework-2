# 天气查询 HarmonyOS 应用



---

## 目录

- [一、项目简介](#一项目简介)
- [二、功能介绍](#二功能介绍)
- [三、技术栈](#三技术栈)
- [四、项目结构](#四项目结构)
- [五、环境配置](#五环境配置)
- [六、部署运行步骤](#六部署运行步骤)
- [七、华为云码道（CodeArts）流水线说明](#七华为云码道codearts流水线说明)
- [八、常见问题 FAQ](#八常见问题-faq)
- [九、项目局限与后续优化方向](#九项目局限与后续优化方向)

---

## 一、项目简介

本项目是基于 **HarmonyOS NEXT（ArkTS / ArkUI 声明式开发范式）** 实现的天气查询应用，作为开源软件开发技术课程"开源实践"环节的作业提交。应用通过调用公共天气接口，支持用户输入城市名称查询当前天气状况及未来天气预报，界面采用 HarmonyOS 原生声明式 UI 开发，并适配手机与平板设备，体现"一次开发，多端部署"的开发理念。

## 二、功能介绍

| 功能点 | 说明 |
| --- | --- |
| 城市天气查询 | 用户在输入框中输入城市名称（支持英文/拼音），点击"查询"按钮获取实时天气 |
| 当前天气展示 | 展示当前温度、体感温度、天气状况描述、湿度、风速 |
| 未来天气预报 | 展示接口返回的未来几日最高/最低温度列表 |
| 加载与异常态 | 查询过程中显示加载动画；网络异常或城市名无效时给出友好提示 |
| 多端适配 | `deviceTypes` 配置为 `phone` 与 `tablet`，UI 采用自适应布局 |

## 三、技术栈

- **开发语言**：ArkTS（TypeScript 超集）
- **UI 范式**：ArkUI 声明式开发范式（Stage 模型）
- **网络请求**：`@ohos.net.http` 系统能力
- **数据来源**：[wttr.in](https://github.com/chubin/wttr.in) 公共天气查询接口（`?format=j1`，**无需申请 API Key**，降低环境配置门槛）
- **目标平台**：HarmonyOS NEXT，API 12（5.0.0）

## 四、项目结构

```
WeatherApp/
├── AppScope/                          # 应用全局配置
│   ├── app.json5
│   └── resources/base/element/string.json
├── entry/                             # entry 模块（主功能模块）
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── entryability/
│   │   │   │   └── EntryAbility.ets   # 应用入口 Ability
│   │   │   ├── pages/
│   │   │   │   └── Index.ets          # 天气查询主界面
│   │   │   └── common/
│   │   │       ├── WeatherModel.ets   # 数据模型定义
│   │   │       └── WeatherService.ets # 网络请求封装
│   │   ├── module.json5               # 模块配置（权限、入口声明）
│   │   └── resources/                 # 字符串/颜色/页面路由等资源
│   ├── build-profile.json5
│   └── oh-package.json5
├── build-profile.json5                # 工程级编译配置
├── oh-package.json5                   # 工程级依赖配置
├── .gitignore
└── README.md
```

## 五、环境配置

| 环境项 | 版本要求 / 说明 |
| --- | --- |
| 操作系统 | Windows 10/11 或 macOS（DevEco Studio 官方支持平台） |
| IDE | **DevEco Studio NEXT** 5.0 及以上版本（[官网下载](https://developer.huawei.com/consumer/cn/deveco-studio/)） |
| HarmonyOS SDK | API 12（5.0.0），通过 DevEco Studio 的 SDK Manager 安装 |
| Node.js | DevEco Studio 自带内置 Node 环境，无需单独安装 |
| 运行设备 | HarmonyOS NEXT 真机，或 DevEco Studio 自带模拟器（Phone / Tablet 镜像） |
| 华为开发者账号 | 真机调试需要登录华为开发者账号并完成实名认证（用于自动签名） |

> 安装步骤：进入 DevEco Studio → `File` → `Settings` → `SDK Manager`，勾选并下载 API 12 对应的 HarmonyOS SDK 组件（包含 Toolchains、Previewer 等）。

## 六、部署运行步骤

由于通过 DevEco Studio 新建工程时会自动生成图标等二进制资源文件（本仓库不包含这些二进制资源以保持仓库轻量），**推荐通过"新建工程 + 替换源码"的方式部署**，具体步骤如下：

### 步骤 1：克隆仓库

```bash
git clone https://github.com/OSSD-Course-SYSU-2/<你的仓库名>.git
```

### 步骤 2：在 DevEco Studio 中新建工程作为骨架

1. 打开 DevEco Studio → `File` → `New` → `Create Project`
2. 选择模板 `Application` → `Empty Ability`，开发语言选择 **ArkTS**
3. `Compatible SDK` 选择 **API 12**，Model 选择 **Stage**
4. 工程名填写 `WeatherApp`，Bundle Name 建议填写 `com.example.weatherapp`（与本仓库 `app.json5` 中一致，避免改名）
5. 完成创建，等待 DevEco Studio 自动同步依赖（首次会下载 `oh_modules`，请保持网络通畅）

### 步骤 3：用本仓库源码覆盖骨架工程

将克隆下来的仓库中以下文件/目录，复制覆盖到第 2 步新建工程的对应路径（**保留新建工程自动生成的 `resources/base/media` 图标资源不要删除**）：

```
AppScope/app.json5
AppScope/resources/base/element/string.json
entry/src/main/module.json5
entry/src/main/resources/base/element/string.json
entry/src/main/resources/base/element/color.json
entry/src/main/resources/base/profile/main_pages.json
entry/src/main/ets/entryability/EntryAbility.ets
entry/src/main/ets/pages/Index.ets
entry/src/main/ets/common/WeatherModel.ets
entry/src/main/ets/common/WeatherService.ets
```

### 步骤 4：配置自动签名

1. 点击菜单 `File` → `Project Structure` → `Signing Configs`
2. 勾选 `Automatically generate signature`，使用华为开发者账号登录后自动生成调试签名

### 步骤 5：选择运行目标并启动

1. 顶部工具栏设备下拉框中选择已连接的真机，或点击 `Device Manager` 启动一个 Phone/Tablet 模拟器
2. 点击绿色 ▶ `Run` 按钮（或快捷键 `Shift + F10`），等待编译、安装、自动拉起应用

### 步骤 6：功能验证

1. 应用启动后，在输入框中输入城市名（如 `Beijing`、`Shanghai`、`Guangzhou`、`Singapore`）
2. 点击"查询"按钮，等待加载动画结束
3. 确认页面展示当前温度、天气描述、湿度、风速及未来天气列表
4. 可尝试输入错误城市名或断网状态，验证异常提示是否正常显示

## 七、华为云码道（CodeArts）流水线说明

按课程要求，作业需通过华为云码道（CodeArts）完成构建/检查并提交至课程组织仓库，建议流程：

1. 登录 [华为云 CodeArts](https://www.huaweicloud.com/product/codearts.html)，创建项目并关联本 GitHub 仓库（或镖仓库镶像同步）
2. 在 CodeArts Pipeline 中新建流水线，选择 HarmonyOS 应用构建模板（或自定义构建任务，执行 `hvigorw assembleHap` 完成 HAP 包构建校验）
3. 确认最终代码已提交并合并至 `https://github.com/OSSD-Course-SYSU-2` 对应仓库

> 此部分具体操作需在你本人的华为云账号环境下完成，本文档仅提供流程框架。

## 八、常见问题 FAQ

| 问题 | 排查建议 |
| --- | --- |
| 编译报错找不到 `$media:icon` | 确认未删除新建工程时自动生成的 `entry/src/main/resources/base/media` 图标资源 |
| 查询接口超时/失败 | 检查设备/模拟器网络连接；`wttr.in` 在部分网络环境下访问较慢，可重试或更换网络 |
| 真机无法安装 | 确认已完成签名配置，且华为账号已完成开发者实名认证 |
| 中文城市名查询失败 | 接口对中文支持有限，建议优先使用英文/拼音城市名（如 `Guangzhou` 而非"广州"） |

## 九、项目局限与后续优化方向

- 当前版本聚焦核心查询功能，尚未实现 HarmonyOS 分布式"自由流转"（跨设备无缝迁移）能力，可作为后续扩展方向
- 天气数据源为公共接口，无 SLA 保障，生产环境建议替换为正式天气服务商 API
- 后续可增加：历史查询记录本地持久化（`@ohos.data.preferences`）、定位自动获取当前城市、多城市卡片管理等功能
