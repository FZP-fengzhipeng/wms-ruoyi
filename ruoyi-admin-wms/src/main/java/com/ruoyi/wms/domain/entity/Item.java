package com.ruoyi.wms.domain.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.mybatis.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_item")
public class Item extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     *
     */
    @TableId(value = "id")
    private Long id;

    /**
     * 编号
     */
    private String itemCode;

    /**
     * 名称
     */
    private String itemName;

    /**
     * 分类
     */
    private String itemCategory;

    /**
     * 计量单位
     */
    private String unit;

    /**
     * 品牌
     */
    private Long itemBrand;

    /**
     * 茶类
     */
    private String teaType;

    /**
     * 产区
     */
    private String teaOrigin;

    /**
     * 等级
     */
    private String teaLevel;

    /**
     * 采摘季
     */
    private String harvestSeason;

    /**
     * 备注
     */
    private String remark;


}
