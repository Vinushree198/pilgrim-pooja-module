<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Vendor Dashboard" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/vendor/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/vendor/items">Items</a><a href="${pageContext.request.contextPath}/vendor/profile">Profile</a><a href="${pageContext.request.contextPath}/vendor/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Welcome, ${vendor.ownerName}!</h2>
    <p><strong>Business:</strong> ${vendor.businessName}</p>
    <p><strong>Status:</strong> ${vendor.status}</p>
    <p><strong>Email:</strong> ${vendor.email}</p>
</div>

<div class="card">
    <h3>My Pooja Items</h3>
    <a href="${pageContext.request.contextPath}/vendor/items/add" class="btn btn-success">Add New Item</a>
    
    <c:if test="${not empty items}">
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${items}">
                    <tr>
                        <td>${item.name}</td>
                        <td>${item.category}</td>
                        <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₹"/></td>
                        <td>${item.stock}</td>
                        <td>${item.status}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/vendor/items/edit/${item.id}" class="btn btn-primary">Edit</a>
                            <a href="${pageContext.request.contextPath}/vendor/items/delete/${item.id}" class="btn btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty items}">
        <p>No items added yet. <a href="${pageContext.request.contextPath}/vendor/items/add">Add your first item</a></p>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>

