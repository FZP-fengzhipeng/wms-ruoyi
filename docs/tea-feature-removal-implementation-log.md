# 茶叶系统功能裁剪实施记录

## 执行时间

- 2026-05-21

## 1. 数据库执行

- 新增脚本：`wms-ruoyi/script/sql/remove_dashboard_and_check_module.sql`
- 已执行内容：
  - 删除茶仓盘点菜单与角色权限绑定；
  - 删除 `wms_check_status` 字典类型与字典项；
  - 清理 `wms_check_order`、`wms_check_order_detail`、盘点流水演示数据。

## 2. 后端执行

- 删除接口文件：
  - `wms-ruoyi/ruoyi-admin-wms/src/main/java/com/ruoyi/wms/controller/CheckOrderController.java`
  - `wms-ruoyi/ruoyi-admin-wms/src/main/java/com/ruoyi/wms/controller/CheckOrderDetailController.java`

## 3. 前端执行

### 3.1 功能裁剪

- 删除盘点前端文件：
  - `RuoYi-WMS-VUE/src/views/wms/order/check/index.vue`
  - `RuoYi-WMS-VUE/src/views/wms/order/check/edit.vue`
  - `RuoYi-WMS-VUE/src/views/wms/order/check/CheckOrderDetail.vue`
  - `RuoYi-WMS-VUE/src/api/wms/checkOrder.js`
  - `RuoYi-WMS-VUE/src/api/wms/checkOrderDetail.js`
  - `RuoYi-WMS-VUE/src/components/PrintTemplate/check-panel.js`
- 删除顶部三入口历史页面：
  - `RuoYi-WMS-VUE/src/views/dashboard/charts.vue`
  - `RuoYi-WMS-VUE/src/views/dashboard/dashboard.vue`
  - `RuoYi-WMS-VUE/src/views/index.vue`
- 路由更新：
  - `RuoYi-WMS-VUE/src/router/index.js`

### 3.2 首页重构与品牌替换

- 新增茶文化首页：
  - `RuoYi-WMS-VUE/src/views/home/teaHome.vue`
- 新增茶叶品牌 Logo：
  - `RuoYi-WMS-VUE/src/assets/logo/tea-logo.svg`
- 品牌替换：
  - `RuoYi-WMS-VUE/src/layout/components/Sidebar/Logo.vue`
  - `RuoYi-WMS-VUE/src/layout/components/Navbar.vue`

## 4. 关联修复

- 默认首页 `/index` 指向 `teaHome`。
- 移除 `/dashboard`、`/description` 等历史入口，避免菜单与路由死链。
