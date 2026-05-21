# 茶叶管理系统改造交付说明

## 1. 初始化数据库

1. 创建数据库并切换：

```sql
CREATE DATABASE IF NOT EXISTS `ry-vue` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ry-vue`;
```

2. 执行脚本：

- `e:/heimashixun/wms-ruoyi/script/sql/wms.sql`

## 2. 后端构建与启动

- 构建验证：

```powershell
D:\maven\apache-maven-3.9.9\bin\mvn.cmd -DskipTests compile -s D:\maven\apache-maven-3.9.9\conf\settings.xml "-Dmaven.repo.local=D:\maven\repository"
```

- 本次改造已验证通过：`BUILD SUCCESS`

## 3. 前端构建与启动

- 开发启动：

```powershell
npm run dev
```

- 生产构建：

```powershell
npm run build:prod
```

- 本次改造已验证通过：`vite build` 成功完成

## 4. 改造范围

- 数据库：字典、菜单、角色菜单、茶企/茶仓/茶品/单据示例数据已替换为中国茶叶业务场景。
- 后端：`Item` 领域新增茶类、产区、等级、采摘季字段；查询条件与导出语义改为茶品。
- 前端：
  - 菜单入口与静态路由标题改为茶业语义。
  - 登录页与主题色改为茶叶风格。
  - 首页驾驶舱与经营大屏改为茶业指标。
  - 茶品管理页改造为茶品字段输入与展示。

## 5. 验收清单

- 登录后可见茶叶化菜单：茶企档案、采购入仓、销售出仓、加工调拨、茶仓盘点、库存分析。
- 茶品管理可维护茶类代码、产区、等级、采摘季。
- 首页和大屏均为茶叶经营数据布局。
- 演示数据中不再出现电子产品、生鲜等非茶叶业务数据。
