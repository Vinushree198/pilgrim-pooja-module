<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Admin Dashboard" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/admin/vendors">Vendors</a><a href="${pageContext.request.contextPath}/admin/items">Items</a><a href="${pageContext.request.contextPath}/admin/orders">Orders</a><a href="${pageContext.request.contextPath}/admin/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Admin Dashboard</h2>
    <p>Welcome, ${admin.name}!</p>
</div>

<div class="grid" style="grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));">
    <div class="card">
        <h3>Pending Vendors</h3>
        <p style="font-size: 2rem; font-weight: bold; color: #e74c3c;">${pendingVendorsCount}</p>
        <a href="${pageContext.request.contextPath}/admin/vendors/pending" class="btn btn-primary">View Pending</a>
    </div>
    
    <div class="card">
        <h3>Total Items</h3>
        <p style="font-size: 2rem; font-weight: bold; color: #3498db;">${totalItems}</p>
        <a href="${pageContext.request.contextPath}/admin/items" class="btn btn-primary">View Items</a>
    </div>
    
    <div class="card">
        <h3>Total Orders</h3>
        <p style="font-size: 2rem; font-weight: bold; color: #27ae60;">${totalOrders}</p>
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-primary">View Orders</a>
    </div>
</div>

<div class="card">
    <h3>Quick Actions</h3>
    <a href="${pageContext.request.contextPath}/admin/vendors/pending" class="btn btn-success">Approve Vendors</a>
    <a href="${pageContext.request.contextPath}/admin/vendors" class="btn btn-primary">Manage Vendors</a>
    <a href="${pageContext.request.contextPath}/admin/items" class="btn btn-primary">Monitor Items</a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-primary">View Orders</a>
</div>

<%@ include file="../common/footer.jsp" %>

