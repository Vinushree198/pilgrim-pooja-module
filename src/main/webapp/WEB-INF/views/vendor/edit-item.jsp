<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Edit Item" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/vendor/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/vendor/items">Items</a><a href="${pageContext.request.contextPath}/vendor/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Edit Pooja Item</h2>
    
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/vendor/items/edit/${item.id}" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label>Item Name *</label>
            <input type="text" name="name" value="${item.name}" required>
        </div>
        
        <div class="form-group">
            <label>Category *</label>
            <select name="category" required>
                <option value="Pooja Items" ${item.category == 'Pooja Items' ? 'selected' : ''}>Pooja Items</option>
                <option value="Idols" ${item.category == 'Idols' ? 'selected' : ''}>Idols</option>
                <option value="Incense" ${item.category == 'Incense' ? 'selected' : ''}>Incense</option>
                <option value="Lamps" ${item.category == 'Lamps' ? 'selected' : ''}>Lamps</option>
                <option value="Books" ${item.category == 'Books' ? 'selected' : ''}>Books</option>
                <option value="Other" ${item.category == 'Other' ? 'selected' : ''}>Other</option>
            </select>
        </div>
        
        <div class="form-group">
            <label>Price (₹) *</label>
            <input type="number" name="price" step="0.01" min="0" value="${item.price}" required>
        </div>
        
        <div class="form-group">
            <label>Quantity/Stock *</label>
            <input type="number" name="stock" min="0" value="${item.stock}" required>
        </div>
        
        <div class="form-group">
            <label>Description</label>
            <textarea name="description" rows="4">${item.description}</textarea>
        </div>
        
        <div class="form-group">
            <label>Current Image</label>
            <c:if test="${not empty item.imagePath}">
                <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.name}" style="width: 100px; height: 100px; object-fit: cover; display: block; margin-bottom: 0.5rem;">
            </c:if>
            <label>Upload New Image (optional)</label>
            <input type="file" name="imageFile" accept="image/*">
        </div>
        
        <button type="submit" class="btn btn-primary">Update Item</button>
        <a href="${pageContext.request.contextPath}/vendor/items" class="btn">Cancel</a>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>

