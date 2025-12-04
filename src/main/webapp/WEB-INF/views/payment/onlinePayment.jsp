<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h2>Online Payment</h2>

<p><b>Order Number:</b> ${order.orderNumber}</p>
<p><b>Amount Payable:</b> ₹ ${order.totalAmount}</p>

<form action="${pageContext.request.contextPath}/customer/payment/submit" method="post">
    <input type="hidden" name="orderId" value="${order.orderNumber}"/>

    <button type="submit" name="status" value="SUCCESS" style="background:green;color:white;padding:10px;">
        Pay Now (Success)
    </button>

    <button type="submit" name="status" value="FAILED" style="background:red;color:white;padding:10px;">
        Fail Payment Test
    </button>
</form>

