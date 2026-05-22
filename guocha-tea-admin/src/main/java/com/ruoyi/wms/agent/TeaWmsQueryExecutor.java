package com.ruoyi.wms.agent;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.core.constant.ServiceConstants;
import com.ruoyi.common.mybatis.core.page.PageQuery;
import com.ruoyi.common.mybatis.core.page.TableDataInfo;
import com.ruoyi.wms.agent.domain.TeaAgentModule;
import com.ruoyi.wms.agent.domain.TeaQueryIntent;
import com.ruoyi.wms.agent.domain.TeaQueryResult;
import com.ruoyi.wms.domain.bo.InventoryBo;
import com.ruoyi.wms.domain.bo.ItemBo;
import com.ruoyi.wms.domain.bo.MerchantBo;
import com.ruoyi.wms.domain.bo.MovementOrderBo;
import com.ruoyi.wms.domain.bo.ReceiptOrderBo;
import com.ruoyi.wms.domain.bo.ShipmentOrderBo;
import com.ruoyi.wms.domain.bo.WarehouseBo;
import com.ruoyi.wms.domain.entity.MovementOrder;
import com.ruoyi.wms.domain.vo.*;
import com.ruoyi.wms.mapper.MovementOrderMapper;
import com.ruoyi.wms.service.InventoryService;
import com.ruoyi.wms.service.ItemService;
import com.ruoyi.wms.service.ItemSkuService;
import com.ruoyi.wms.service.MerchantService;
import com.ruoyi.wms.service.MovementOrderService;
import com.ruoyi.wms.service.ReceiptOrderService;
import com.ruoyi.wms.service.ShipmentOrderService;
import com.ruoyi.wms.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TeaWmsQueryExecutor {

    private final ReceiptOrderService receiptOrderService;
    private final ShipmentOrderService shipmentOrderService;
    private final MovementOrderService movementOrderService;
    private final MovementOrderMapper movementOrderMapper;
    private final MerchantService merchantService;
    private final WarehouseService warehouseService;
    private final ItemService itemService;
    private final ItemSkuService itemSkuService;
    private final InventoryService inventoryService;

    public TeaQueryResult execute(TeaQueryIntent intent) {
        if ("RECALL".equals(intent.getAction())) {
            return recallFromSession(intent);
        }
        if ("UNMATCHED".equals(intent.getAction())) {
            return queryUnmatched(intent);
        }
        return switch (intent.getModule()) {
            case RECEIPT -> queryReceipt(intent);
            case SHIPMENT -> queryShipment(intent);
            case MOVEMENT -> queryMovement(intent);
            case INVENTORY -> queryInventory(intent);
            case OVERVIEW -> queryOverview(intent);
            default -> queryUnmatched(intent);
        };
    }

    private TeaQueryResult queryUnmatched(TeaQueryIntent intent) {
        TeaQueryResult result = new TeaQueryResult();
        result.setModuleLabel("查询提示");
        result.setPrefillBriefSummary(false);
        result.setBriefSummary("暂无法根据您的问题直接查询到结果。您可以尝试：\n"
            + "1. 输入单号，如：单号 CR05216556\n"
            + "2. 问三个模块待处理数量，如：三个模块各有多少待处理单据？\n"
            + "3. 问茶品在哪个茶仓，如：白牡丹在哪个茶仓有库存？");
        result.setDataContext(result.getBriefSummary());
        result.getNavigateHints().add("茶仓库存 → /teaInventory/inventory");
        return result;
    }

    private TeaQueryResult queryInventory(TeaQueryIntent intent) {
        TeaQueryResult result = new TeaQueryResult();
        result.setModuleLabel("茶仓库存");
        if (intent.getItemKeyword() == null) {
            result.setBriefSummary("请说明要查询的茶品名称，例如：白牡丹在哪个茶仓有库存？");
            result.setDataContext(result.getBriefSummary());
            return result;
        }
        ItemBo itemBo = new ItemBo();
        itemBo.setItemName(intent.getItemKeyword());
        List<ItemVo> items = itemService.queryList(itemBo);
        if (items.isEmpty()) {
            result.setBriefSummary("未找到名称包含「" + intent.getItemKeyword() + "」的茶品。");
            result.setDataContext(result.getBriefSummary());
            return result;
        }
        StringBuilder sb = new StringBuilder();
        sb.append("茶品「").append(intent.getItemKeyword()).append("」库存分布：\n");
        boolean hasStock = false;
        for (ItemVo item : items) {
            for (ItemSkuVo sku : itemSkuService.queryByItemId(item.getId())) {
                InventoryBo invBo = new InventoryBo();
                invBo.setSkuId(sku.getId());
                for (InventoryVo inv : inventoryService.queryList(invBo)) {
                    if (inv.getQuantity() == null || inv.getQuantity().signum() <= 0) {
                        continue;
                    }
                    hasStock = true;
                    String whName = resolveWarehouseName(inv.getWarehouseId());
                    sb.append("- ").append(item.getItemName())
                        .append(" / ").append(sku.getSkuName() != null ? sku.getSkuName() : "规格")
                        .append(" | 茶仓:").append(whName)
                        .append(" | 数量:").append(inv.getQuantity()).append("\n");
                }
            }
        }
        if (!hasStock) {
            result.setBriefSummary("茶品「" + intent.getItemKeyword() + "」当前无库存记录。");
            result.setDataContext(sb.append("（无库存）").toString());
        } else {
            result.setBriefSummary("已查询茶品「" + intent.getItemKeyword() + "」在各茶仓的库存。");
            result.setDataContext(sb.toString());
        }
        result.getNavigateHints().add("茶仓库存 → /teaInventory/inventory");
        return result;
    }

    private String resolveWarehouseName(Long warehouseId) {
        if (warehouseId == null) {
            return "未知茶仓";
        }
        WarehouseVo wh = warehouseService.queryById(warehouseId);
        return wh != null && wh.getWarehouseName() != null ? wh.getWarehouseName() : String.valueOf(warehouseId);
    }

    private TeaQueryResult recallFromSession(TeaQueryIntent intent) {
        TeaQueryResult result = new TeaQueryResult();
        result.setModuleLabel("会话记忆");
        if (intent.getOrderNo() == null) {
            result.setBriefSummary("本轮对话中还没有查询过具体单号。您可以先输入单号查询，例如：单号 CR05216556。");
            result.setDataContext(result.getBriefSummary());
            return result;
        }
        String moduleLabel = switch (intent.getModule()) {
            case RECEIPT -> "采购入仓";
            case SHIPMENT -> "销售出仓";
            case MOVEMENT -> "加工调拨";
            default -> "业务单据";
        };
        result.setModuleLabel(moduleLabel);
        result.setLastOrderNo(intent.getOrderNo());
        result.setBriefSummary("您刚才查询的单号是：" + intent.getOrderNo() + "（" + moduleLabel + "）。");
        result.setDataContext(result.getBriefSummary());
        return result;
    }

    private TeaQueryResult queryOverview(TeaQueryIntent intent) {
        TeaQueryResult result = new TeaQueryResult();
        result.setModuleLabel("三模块概览");
        long receiptPending = countReceipt(0);
        long receiptDone = countReceipt(1);
        long shipmentPending = countShipment(0);
        long shipmentDone = countShipment(1);
        long movementPending = countMovement(0);
        long movementDone = countMovement(1);
        result.setBriefSummary(String.format(
            "采购入仓：待入仓 %d 单，已入仓 %d 单；销售出仓：待出仓 %d 单，已出仓 %d 单；加工调拨：待调拨 %d 单，已调拨 %d 单。",
            receiptPending, receiptDone, shipmentPending, shipmentDone, movementPending, movementDone));
        result.setDataContext(result.getBriefSummary());
        result.getNavigateHints().add("采购入仓 → /teaReceipt/receiptOrder");
        result.getNavigateHints().add("销售出仓 → /teaShipment/shipmentOrder");
        result.getNavigateHints().add("加工调拨 → /teaMovement/movementOrder");
        return result;
    }

    private TeaQueryResult queryReceipt(TeaQueryIntent intent) {
        TeaQueryResult result = new TeaQueryResult();
        result.setModuleLabel("采购入仓");
        if ("DETAIL".equals(intent.getAction()) && intent.getOrderNo() != null) {
            Long id = receiptOrderService.queryIdByOrderNo(intent.getOrderNo());
            if (id == null) {
                result.setBriefSummary("未找到入仓单：" + intent.getOrderNo());
                result.setDataContext(result.getBriefSummary());
                return result;
            }
            ReceiptOrderVo vo = receiptOrderService.queryById(id);
            result.setBriefSummary("入仓单 " + vo.getOrderNo() + "，状态 " + statusLabel(vo.getOrderStatus()) +
                "，数量 " + vo.getTotalQuantity() + "，金额 " + vo.getTotalAmount());
            result.setDataContext(formatReceiptDetail(vo));
            result.setLastOrderNo(vo.getOrderNo());
            result.getNavigateHints().add("/teaReceipt/receiptOrderEdit?id=" + id);
            return result;
        }
        ReceiptOrderBo bo = new ReceiptOrderBo();
        bo.setOrderStatus(intent.getOrderStatus());
        bo.setMerchantId(resolveMerchantId(intent.getMerchantKeyword()));
        bo.setWarehouseId(resolveWarehouseId(intent.getWarehouseKeyword()));
        TableDataInfo<ReceiptOrderVo> page = receiptOrderService.queryPageList(bo, pageQuery(intent.getLimit()));
        result.setBriefSummary("共查询到 " + page.getTotal() + " 条采购入仓单，展示前 " + page.getRows().size() + " 条。");
        result.setDataContext(formatReceiptList(page.getRows()));
        result.getNavigateHints().add("/teaReceipt/receiptOrder");
        return result;
    }

    private TeaQueryResult queryShipment(TeaQueryIntent intent) {
        TeaQueryResult result = new TeaQueryResult();
        result.setModuleLabel("销售出仓");
        if ("DETAIL".equals(intent.getAction()) && intent.getOrderNo() != null) {
            Long id = shipmentOrderService.queryIdByOrderNo(intent.getOrderNo());
            if (id == null) {
                result.setBriefSummary("未找到出仓单：" + intent.getOrderNo());
                result.setDataContext(result.getBriefSummary());
                return result;
            }
            ShipmentOrderVo vo = shipmentOrderService.queryById(id);
            result.setBriefSummary("出仓单 " + vo.getOrderNo() + "，状态 " + statusLabel(vo.getOrderStatus()));
            result.setDataContext(formatShipmentDetail(vo));
            result.setLastOrderNo(vo.getOrderNo());
            result.getNavigateHints().add("/teaShipment/shipmentOrderEdit?id=" + id);
            return result;
        }
        ShipmentOrderBo bo = new ShipmentOrderBo();
        bo.setOrderStatus(intent.getOrderStatus());
        bo.setMerchantId(resolveMerchantId(intent.getMerchantKeyword()));
        bo.setWarehouseId(resolveWarehouseId(intent.getWarehouseKeyword()));
        TableDataInfo<ShipmentOrderVo> page = shipmentOrderService.queryPageList(bo, pageQuery(intent.getLimit()));
        result.setBriefSummary("共 " + page.getTotal() + " 条销售出仓单。");
        result.setDataContext(formatShipmentList(page.getRows()));
        result.getNavigateHints().add("/teaShipment/shipmentOrder");
        return result;
    }

    private TeaQueryResult queryMovement(TeaQueryIntent intent) {
        TeaQueryResult result = new TeaQueryResult();
        result.setModuleLabel("加工调拨");
        if ("DETAIL".equals(intent.getAction()) && intent.getOrderNo() != null) {
            MovementOrderVo one = movementOrderMapper.selectVoOne(
                Wrappers.<MovementOrder>lambdaQuery().eq(MovementOrder::getOrderNo, intent.getOrderNo()));
            if (one == null) {
                result.setBriefSummary("未找到调拨单：" + intent.getOrderNo());
                result.setDataContext(result.getBriefSummary());
                return result;
            }
            MovementOrderVo vo = movementOrderService.queryById(one.getId());
            result.setBriefSummary("调拨单 " + vo.getOrderNo() + "，状态 " + statusLabel(vo.getOrderStatus()));
            result.setDataContext(formatMovementDetail(vo));
            result.setLastOrderNo(vo.getOrderNo());
            result.getNavigateHints().add("/teaMovement/movementOrderEdit?id=" + vo.getId());
            return result;
        }
        MovementOrderBo bo = new MovementOrderBo();
        bo.setOrderStatus(intent.getOrderStatus());
        Long whId = resolveWarehouseId(intent.getWarehouseKeyword());
        if (whId != null) {
            bo.setSourceWarehouseId(whId);
        }
        TableDataInfo<MovementOrderVo> page = movementOrderService.queryPageList(bo, pageQuery(intent.getLimit()));
        result.setBriefSummary("共 " + page.getTotal() + " 条加工调拨单。");
        result.setDataContext(formatMovementList(page.getRows()));
        result.getNavigateHints().add("/teaMovement/movementOrder");
        return result;
    }

    private long countReceipt(int status) {
        ReceiptOrderBo bo = new ReceiptOrderBo();
        bo.setOrderStatus(status);
        return receiptOrderService.queryList(bo).size();
    }

    private long countShipment(int status) {
        ShipmentOrderBo bo = new ShipmentOrderBo();
        bo.setOrderStatus(status);
        return shipmentOrderService.queryList(bo).size();
    }

    private long countMovement(int status) {
        MovementOrderBo bo = new MovementOrderBo();
        bo.setOrderStatus(status);
        return movementOrderService.queryList(bo).size();
    }

    private Long resolveMerchantId(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return null;
        }
        MerchantBo bo = new MerchantBo();
        bo.setMerchantName(keyword);
        List<MerchantVo> list = merchantService.queryList(bo);
        return list.isEmpty() ? null : list.get(0).getId();
    }

    private Long resolveWarehouseId(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return null;
        }
        return warehouseService.queryList(new WarehouseBo()).stream()
            .filter(w -> w.getWarehouseName() != null && w.getWarehouseName().contains(keyword))
            .map(WarehouseVo::getId)
            .findFirst()
            .orElse(null);
    }

    private String statusLabel(Integer status) {
        if (status == null) {
            return "未知";
        }
        if (ServiceConstants.ReceiptOrderStatus.PENDING.equals(status)) {
            return "待处理";
        }
        if (ServiceConstants.ReceiptOrderStatus.FINISH.equals(status)) {
            return "已完成";
        }
        if (ServiceConstants.ReceiptOrderStatus.INVALID.equals(status)) {
            return "作废";
        }
        return String.valueOf(status);
    }

    private String formatReceiptList(List<ReceiptOrderVo> rows) {
        if (rows.isEmpty()) {
            return "无数据";
        }
        return rows.stream()
            .map(r -> "- " + r.getOrderNo() + " | 状态:" + statusLabel(r.getOrderStatus())
                + " | 数量:" + r.getTotalQuantity() + " | 金额:" + r.getTotalAmount())
            .collect(Collectors.joining("\n"));
    }

    private String formatReceiptDetail(ReceiptOrderVo vo) {
        StringBuilder sb = new StringBuilder();
        sb.append("单号:").append(vo.getOrderNo()).append("\n状态:").append(statusLabel(vo.getOrderStatus()));
        sb.append("\n总数量:").append(vo.getTotalQuantity()).append(" 总金额:").append(vo.getTotalAmount());
        if (vo.getDetails() != null) {
            vo.getDetails().forEach(d -> sb.append("\n  - ")
                .append(d.getItemSku() != null ? d.getItemSku().getSkuName() : "规格")
                .append(" x").append(d.getQuantity()).append(" 金额:").append(d.getAmount()));
        }
        return sb.toString();
    }

    private String formatShipmentList(List<ShipmentOrderVo> rows) {
        if (rows.isEmpty()) {
            return "无数据";
        }
        return rows.stream()
            .map(r -> "- " + r.getOrderNo() + " | 状态:" + statusLabel(r.getOrderStatus())
                + " | 数量:" + r.getTotalQuantity())
            .collect(Collectors.joining("\n"));
    }

    private String formatShipmentDetail(ShipmentOrderVo vo) {
        StringBuilder sb = new StringBuilder();
        sb.append("单号:").append(vo.getOrderNo()).append("\n状态:").append(statusLabel(vo.getOrderStatus()));
        sb.append("\n总数量:").append(vo.getTotalQuantity()).append(" 总金额:").append(vo.getTotalAmount());
        if (vo.getDetails() != null) {
            vo.getDetails().forEach(d -> sb.append("\n  - ")
                .append(d.getItemSku() != null ? d.getItemSku().getSkuName() : "规格")
                .append(" x").append(d.getQuantity()).append(" 金额:").append(d.getAmount()));
        }
        return sb.toString();
    }

    private String formatMovementList(List<MovementOrderVo> rows) {
        if (rows.isEmpty()) {
            return "无数据";
        }
        return rows.stream()
            .map(r -> "- " + r.getOrderNo() + " | 状态:" + statusLabel(r.getOrderStatus())
                + " | 数量:" + r.getTotalQuantity())
            .collect(Collectors.joining("\n"));
    }

    private String formatMovementDetail(MovementOrderVo vo) {
        StringBuilder sb = new StringBuilder();
        sb.append("单号:").append(vo.getOrderNo()).append("\n状态:").append(statusLabel(vo.getOrderStatus()));
        sb.append("\n总数量:").append(vo.getTotalQuantity());
        if (vo.getDetails() != null) {
            vo.getDetails().forEach(d -> sb.append("\n  - 数量:").append(d.getQuantity()));
        }
        return sb.toString();
    }

    private PageQuery pageQuery(int limit) {
        PageQuery pageQuery = new PageQuery();
        pageQuery.setPageNum(1);
        pageQuery.setPageSize(limit);
        return pageQuery;
    }
}
