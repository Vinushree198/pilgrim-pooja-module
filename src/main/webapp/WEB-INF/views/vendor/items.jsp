<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="My Items" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/vendor/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/vendor/items">Items</a><a href="${pageContext.request.contextPath}/vendor/profile">Profile</a><a href="${pageContext.request.contextPath}/vendor/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>My Pooja Items</h2>
    <a href="${pageContext.request.contextPath}/vendor/items/add" class="btn btn-success">Add New Item</a>
    
    <c:if test="${not empty items}">
        <table>
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Reserved</th>
                    <th>Sold</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${items}">
                    <tr>
                        <td>
                            <c:if test="${not empty item.imagePath}">
                                <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.name}" style="width: 50px; height: 50px; object-fit: cover;">
                            </c:if>
                        </td>
                        <td>${item.name}</td>
                        <td>${item.category}</td>
                        <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₹"/></td>
                        <td>${item.stock}</td>
                        <td>${item.reservedStock}</td>
                        <td>${item.soldStock}</td>
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

