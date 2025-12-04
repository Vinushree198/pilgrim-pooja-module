<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Pooja Module - Home" />
<%@ include file="common/header.jsp" %>

<div class="card" style="text-align: center; padding: 3rem;">
    <h1 style="font-size: 2.5rem; margin-bottom: 1rem;">Welcome to Pooja Module</h1>
    <p style="font-size: 1.2rem; color: #666; margin-bottom: 2rem;">Your one-stop solution for managing pooja items</p>
    
    <div class="grid" style="grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); margin-top: 2rem;">
        <div class="card">
            <h3>Vendor Portal</h3>
            <p>Register as a vendor and manage your pooja items</p>
            <a href="${pageContext.request.contextPath}/vendor/register" class="btn btn-primary">Vendor Registration</a>
            <a href="${pageContext.request.contextPath}/vendor/login" class="btn" style="margin-top: 0.5rem;">Vendor Login</a>
        </div>
        
        <div class="card">
            <h3>Customer Portal</h3>
            <p>Browse and purchase pooja items</p>
            <a href="${pageContext.request.contextPath}/customer/register" class="btn btn-primary">Customer Registration</a>
            <a href="${pageContext.request.contextPath}/customer/login" class="btn" style="margin-top: 0.5rem;">Customer Login</a>
        </div>
        
        <div class="card">
            <h3>Admin Portal</h3>
            <p>Manage vendors, items, and orders</p>
            <a href="${pageContext.request.contextPath}/admin/register" class="btn btn-primary">Admin Registration</a>
            <a href="${pageContext.request.contextPath}/admin/login" class="btn" style="margin-top: 0.5rem;">Admin Login</a>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>

