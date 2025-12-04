<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Customer Dashboard" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/customer/items">Browse Items</a><a href="${pageContext.request.contextPath}/customer/cart">Cart</a><a href="${pageContext.request.contextPath}/customer/orders">Orders</a><a href="${pageContext.request.contextPath}/customer/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Welcome, ${customer.name}!</h2>
    <p><strong>Email:</strong> ${customer.email}</p>
</div>

<div class="card">
    <h3>Available Pooja Items</h3>
    <a href="${pageContext.request.contextPath}/customer/items" class="btn btn-primary">Browse All Items</a>
    
    <c:if test="${not empty items}">
        <div class="grid">
            <c:forEach var="item" items="${items}" begin="0" end="5">
                <div class="item-card">
                    <c:if test="${not empty item.imagePath}">
                        <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.name}">
                    </c:if>
                    <div class="item-card-body">
                        <h4>${item.name}</h4>
                        <p><strong>Category:</strong> ${item.category}</p>
                        <p><strong>Price:</strong> <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₹"/></p>
                        <p><strong>Stock:</strong> ${item.stock}</p>
                        <a href="${pageContext.request.contextPath}/customer/items/${item.id}" class="btn btn-primary">View Details</a>
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

