package com.yang.servier.impl;

import com.yang.mapper.FinanceMapper;
import com.yang.mapper.OrderMapper;
import com.yang.pojo.Finance;
import com.yang.pojo.GuetOrder;
import com.yang.servier.IGuetOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class GuetOrderServiceImpl implements IGuetOrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private FinanceMapper financeMapper;

    @Override
    public List<GuetOrder> selectByUserIdWithCustomer(Long userId) {
        return orderMapper.selectByUserIdWithCustomer(userId);
    }

    @Override
    public List<GuetOrder> selectAll() {
        return orderMapper.selectAll();
    }

    @Override
    public GuetOrder selectById(Integer id) {
        return orderMapper.selectById(id);
    }

    @Override
    public List<GuetOrder> selectByCondition(GuetOrder order) {
        return orderMapper.selectByCondition(order);
    }

    @Override
    public List<GuetOrder> selectByUserId(Long userId) {
        return orderMapper.selectByUserId(userId);
    }

    @Override
    public int insert(GuetOrder order) {
        return orderMapper.insert(order);
    }

    @Override
    @Transactional
    public int update(GuetOrder order) {
        int result = orderMapper.update(order);
        if (result > 0 && order.getTotal() != null) {
            Finance finance = financeMapper.selectByOrderId(order.getId());
            if (finance != null) {
                BigDecimal newTotal = new BigDecimal(order.getTotal());
                BigDecimal paidAmount = finance.getPaidAmount() != null ? finance.getPaidAmount() : BigDecimal.ZERO;
                BigDecimal unpaidAmount = newTotal.subtract(paidAmount);
                
                finance.setTotalAmount(newTotal);
                finance.setUnpaidAmount(unpaidAmount);
                
                if (unpaidAmount.compareTo(BigDecimal.ZERO) == 0) {
                    finance.setPaymentStatus(3);
                } else if (paidAmount.compareTo(BigDecimal.ZERO) > 0) {
                    finance.setPaymentStatus(2);
                } else {
                    finance.setPaymentStatus(1);
                }
                
                financeMapper.update(finance);
            }
        }
        return result;
    }

    @Override
    public int deleteById(Integer id) {
        return orderMapper.deleteById(id);
    }
}
