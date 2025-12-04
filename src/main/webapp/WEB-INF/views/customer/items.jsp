<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Browse Items" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/customer/items">Browse Items</a><a href="${pageContext.request.contextPath}/customer/cart">Cart</a><a href="${pageContext.request.contextPath}/customer/orders">Orders</a><a href="${pageContext.request.contextPath}/customer/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Browse Pooja Items</h2>
    <p>Only approved items with stock > 0 are shown</p>
    
    <!-- 🔍 Search + Filter + Sort Section -->
<form action="${pageContext.request.contextPath}/customer/items" method="get" style="margin-bottom:20px; display:flex; gap:10px; flex-wrap:wrap;">

    <!-- Search -->
    <input type="text" name="search" value="${param.search}" placeholder="Search items..."
           style="padding:8px; width:200px; border:1px solid #ccc; border-radius:5px;">

    <!-- Category Dropdown -->
    <select name="category" style="padding:8px; border:1px solid #ccc; border-radius:5px;">
        <option value="">All Categories</option>

        <!-- Dynamically list categories (You must send 'categories' from controller) -->
        <c:forEach var="cat" items="${categories}">
            <option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
        </c:forEach>
    </select>

    <!-- Sorting -->
    <select name="sort" style="padding:8px; border:1px solid #ccc; border-radius:5px;">
        <option value="">Sort By</option>
        <option value="low"  ${param.sort=='low'?'selected':''}>Price: Low → High</option>
        <option value="high" ${param.sort=='high'?'selected':''}>Price: High → Low</option>
        <option value="new"  ${param.sort=='new'?'selected':''}>Newest Items</option>
    </select>

    <!-- Submit Button -->
    <button type="submit" class="btn btn-primary">Apply</button>
</form>
    
    
    <c:if test="${not empty items}">
        <div class="grid">
            <c:forEach var="item" items="${items}">
                <div class="item-card">
                    <c:if test="${not empty item.imagePath}">
                        <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.name}">
                    </c:if>
                    <div class="item-card-body">
                        <h4>${item.name}</h4>
                        <p><strong>Category:</strong> ${item.category}</p>
                        <p><strong>Price:</strong> <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₹"/></p>
                        <p><strong>Stock:</strong> ${item.stock}</p>
                        <p><strong>Vendor:</strong> ${item.vendor.businessName}</p>
                        <c:if test="${not empty item.description}">
                            <p style="font-size: 0.9rem; color: #666;">${item.description}</p>
                        </c:if>
                        <div style="margin-top: 1rem;">
                            <a href="${pageContext.request.contextPath}/customer/items/${item.id}" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    <c:if test="${empty items}">
        <p>No items available at the moment.</p>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>

