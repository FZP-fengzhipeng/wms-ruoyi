# 茶叶管理领域映射

## 业务域映射（保持接口风格）

- `wms_warehouse` -> 茶仓（产区仓、加工仓、成品仓）
- `wms_merchant` -> 茶企往来单位（茶园合作社、供应商、经销商）
- `wms_item` -> 茶品主档（茶品编码、茶名、茶类、产区、等级、采摘季）
- `wms_item_sku` -> 茶品规格（包装规格、克重、建议零售价）
- `wms_receipt_order` -> 采购/回仓入库单
- `wms_shipment_order` -> 销售/调拨出库单
- `wms_movement_order` -> 加工移库单（原料仓 -> 成品仓）
- `wms_check_order` -> 茶仓盘点单
- `wms_inventory_history` -> 茶仓库存流水

## 字典设计

- `merchant_type`: 采购方、供应方、经销方
- `wms_receipt_type`: 春茶采购入库、秋茶采购入库、退货回仓
- `wms_shipment_type`: 渠道销售出库、电商零售出库、样品出库
- `wms_inventory_history_type`: 入库、出库、移库、盘点
- `wms_tea_type`: 绿茶、红茶、乌龙茶、白茶、黑茶、黄茶、普洱茶
- `wms_tea_level`: 特级、一级、二级、三级
- `wms_harvest_season`: 明前、雨前、春尾、夏茶、秋茶

## 菜单重构目标

- 茶企档案（茶企管理、茶仓管理）
- 茶品中心（茶品档案、品牌产地）
- 采购入仓（入库单）
- 销售出仓（出库单）
- 加工调拨（移库单）
- 茶仓盘点（盘库单）
- 库存分析（库存统计、库存流水）

## 接口兼容策略

- 保留 `/wms/*` 路径与前端 `src/api/wms/*` 结构。
- 前后端以“语义重构 + 字段扩展”为主，避免大规模接口重命名带来的联调风险。
