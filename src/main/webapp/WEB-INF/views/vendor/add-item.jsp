<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Add Item" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/vendor/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/vendor/items">Items</a><a href="${pageContext.request.contextPath}/vendor/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Add New Pooja Item</h2>
    
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/vendor/items/add" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label>Item Name *</label>
            <input type="text" name="name" required>
        </div>
        
        <div class="form-group">
            <label>Category *</label>
            <select name="category" required>
                <option value="">Select Category</option>
                <option value="Pooja Items">Pooja Items</option>
                <option value="Idols">Idols</option>
                <option value="Incense">Incense</option>
                <option value="Lamps">Lamps</option>
                <option value="Books">Books</option>
                <option value="Other">Other</option>
            </select>
        </div>
        
        <div class="form-group">
            <label>Price (₹) *</label>
            <input type="number" name="price" step="0.01" min="0" required>
        </div>
        
        <div class="form-group">
            <label>Quantity/Stock *</label>
            <input type="number" name="stock" min="0" required>
        </div>
        
        <div class="form-group">
            <label>Description</label>
            <textarea name="description" rows="4"></textarea>
        </div>
        
        <div class="form-group">
            <label>Image</label>
            <input type="file" name="imageFile" accept="image/*">
        </div>
        
        <button type="submit" class="btn btn-primary">Add Item</button>
        <a href="${pageContext.request.contextPath}/vendor/items" class="btn">Cancel</a>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>

