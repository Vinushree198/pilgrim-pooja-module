<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Item Monitoring" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/admin/vendors">Vendors</a><a href="${pageContext.request.contextPath}/admin/items">Items</a><a href="${pageContext.request.contextPath}/admin/orders">Orders</a><a href="${pageContext.request.contextPath}/admin/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>All Pooja Items - Monitoring</h2>
    
    <c:if test="${not empty items}">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Reserved</th>
                    <th>Sold</th>
                    <th>Vendor</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${items}">
                    <tr>
                        <td>${item.id}</td>
                        <td>
                            <c:if test="${not empty item.imagePath}">
                                <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.name}" style="width: 50px; height: 50px; object-fit: cover;">
                            </c:if>
                        </td>
                        <td>${item.name}</td>
                        <td>${item.category}</td>
                        <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₹"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${item.stock == 0}">
                                    <span style="color: #e74c3c; font-weight: bold;">OUT OF STOCK</span>
                                </c:when>
                                <c:when test="${item.stock < 10}">
                                    <span style="color: #f39c12; font-weight: bold;">LOW (${item.stock})</span>
                                </c:when>
                                <c:otherwise>
                                    ${item.stock}
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${item.reservedStock}</td>
                        <td>${item.soldStock}</td>
                        <td>${item.vendor.businessName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.status == 'ACTIVE'}">
                                    <span style="color: #27ae60;">ACTIVE</span>
                                </c:when>
                                <c:when test="${item.status == 'BLOCKED'}">
                                    <span style="color: #e74c3c;">BLOCKED</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #95a5a6;">DELETED</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${item.status == 'ACTIVE'}">
                                <form action="${pageContext.request.contextPath}/admin/items/block/${item.id}" method="post" style="display: inline;">
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Block this item?')">Block</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty items}">
        <p>No items found.</p>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>

