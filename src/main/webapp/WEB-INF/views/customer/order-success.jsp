<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Order Success" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/customer/items">Browse Items</a><a href="${pageContext.request.contextPath}/customer/orders">Orders</a><a href="${pageContext.request.contextPath}/customer/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card" style="text-align: center; max-width: 600px; margin: 2rem auto;">
    <h2 style="color: #27ae60;">✓ Order Placed Successfully!</h2>
    
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    
    <p style="font-size: 1.2rem; margin: 1rem 0;">Your order has been placed and vendors have been notified.</p>
    <p style="margin: 1rem 0;">Stock has been updated automatically.</p>
    
    <div style="margin-top: 2rem;">
        <a href="${pageContext.request.contextPath}/customer/orders" class="btn btn-primary">View My Orders</a>
        <a href="${pageContext.request.contextPath}/customer/items" class="btn btn-success">Continue Shopping</a>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

