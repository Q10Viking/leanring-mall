package com.tuling.tulingmall.mapper;

import com.baomidou.dynamic.datasource.annotation.DS;
import com.tuling.tulingmall.model.SmsFlashPromotionLog;
import com.tuling.tulingmall.model.SmsFlashPromotionLogExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;
@DS("promotion")
public interface SmsFlashPromotionLogMapper {
    long countByExample(SmsFlashPromotionLogExample example);

    int deleteByExample(SmsFlashPromotionLogExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(SmsFlashPromotionLog record);

    int insertSelective(SmsFlashPromotionLog record);

    List<SmsFlashPromotionLog> selectByExample(SmsFlashPromotionLogExample example);

    SmsFlashPromotionLog selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") SmsFlashPromotionLog record, @Param("example") SmsFlashPromotionLogExample example);

    int updateByExample(@Param("record") SmsFlashPromotionLog record, @Param("example") SmsFlashPromotionLogExample example);

    int updateByPrimaryKeySelective(SmsFlashPromotionLog record);

    int updateByPrimaryKey(SmsFlashPromotionLog record);
}