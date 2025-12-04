<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${item.name}" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/customer/items">Browse Items</a><a href="${pageContext.request.contextPath}/customer/cart">Cart</a><a href="${pageContext.request.contextPath}/customer/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
        <div>
            <c:if test="${not empty item.imagePath}">
                <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.name}" style="width: 100%; border-radius: 8px;">
            </c:if>
        </div>
        <div>
            <h2>${item.name}</h2>
            <p><strong>Category:</strong> ${item.category}</p>
            <p><strong>Price:</strong> <span style="font-size: 1.5rem; color: #27ae60; font-weight: bold;"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₹"/></span></p>
            <p><strong>Stock Available:</strong> 
                <c:choose>
                    <c:when test="${item.stock > 0}">
                        <span style="color: #27ae60; font-weight: bold;">${item.stock} units</span>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #e74c3c; font-weight: bold;">Out of Stock</span>
                    </c:otherwise>
                </c:choose>
            </p>
            <p><strong>Vendor:</strong> ${item.vendor.businessName}</p>
            
            <c:if test="${not empty item.description}">
                <div style="margin: 1rem 0;">
                    <h4>Description</h4>
                    <p>${item.description}</p>
                </div>
            </c:if>
            
            <c:if test="${item.stock > 0}">
                <form action="${pageContext.request.contextPath}/customer/cart/add" method="post" style="margin-top: 1rem;">
                    <input type="hidden" name="itemId" value="${item.id}">
                    <div class="form-group">
                        <label>Quantity</label>
                        <input type="number" name="quantity" value="1" min="1" max="${item.stock}" required>
                    </div>
                    <button type="submit" class="btn btn-success">Add to Cart</button>
                </form>
            </c:if>
            <c:if test="${item.stock == 0}">
                <p style="color: #e74c3c; font-weight: bold; margin-top: 1rem;">This item is currently out of stock.</p>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

