package com.tuling.tulingmall.mapper;

import com.baomidou.dynamic.datasource.annotation.DS;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tuling.tulingmall.model.PmsProductFullReduction;
import org.springframework.stereotype.Repository;

@DS("goods")
@Repository
public interface PmsProductFullReductionMapper extends BaseMapper<PmsProductFullReduction> {
}