<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Order Monitoring" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/admin/vendors">Vendors</a><a href="${pageContext.request.contextPath}/admin/items">Items</a><a href="${pageContext.request.contextPath}/admin/orders">Orders</a><a href="${pageContext.request.contextPath}/admin/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>All Orders</h2>
    
    <c:if test="${not empty orders}">
        <table>
            <thead>
                <tr>
                    <th>Order Number</th>
                    <th>Customer</th>
                    <th>Vendor</th>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Created At</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>${order.orderNumber}</td>
                        <td>${order.customer.name} (${order.customer.email})</td>
                        <td>${order.vendor.businessName}</td>
                        <td>${order.item.name}</td>
                        <td>${order.quantity}</td>
                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₹"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}">
                                    <span style="color: #f39c12;">PENDING</span>
                                </c:when>
                                <c:when test="${order.status == 'CONFIRMED'}">
                                    <span style="color: #3498db;">CONFIRMED</span>
                                </c:when>
                                <c:when test="${order.status == 'SHIPPED'}">
                                    <span style="color: #9b59b6;">SHIPPED</span>
                                </c:when>
                                <c:when test="${order.status == 'DELIVERED'}">
                                    <span style="color: #27ae60;">DELIVERED</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #e74c3c;">CANCELLED</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${order.createdAt}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty orders}">
        <p>No orders found.</p>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>

