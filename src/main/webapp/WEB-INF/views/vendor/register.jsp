<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Vendor Registration" />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Vendor Registration</h2>
    
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/vendor/register" method="post">
        <div class="form-group">
            <label>Business Name *</label>
            <input type="text" name="businessName" required>
        </div>
        
        <div class="form-group">
            <label>Owner Name *</label>
            <input type="text" name="ownerName" required>
        </div>
        
        <div class="form-group">
            <label>Email *</label>
            <input type="email" name="email" required>
        </div>
        
        <div class="form-group">
            <label>Phone *</label>
            <input type="tel" name="phone" required>
        </div>
        
        <div class="form-group">
            <label>Business Type *</label>
            <select name="businessType" required>
                <option value="">Select Business Type</option>
                <option value="Retail">Retail</option>
                <option value="Wholesale">Wholesale</option>
                <option value="Online">Online</option>
                <option value="Other">Other</option>
            </select>
        </div>
        
        <div class="form-group">
            <label>Address *</label>
            <textarea name="address" rows="3" required></textarea>
        </div>
        
        <div class="form-group">
            <label>Password *</label>
            <input type="password" name="password" required>
        </div>
        
        <button type="submit" class="btn btn-primary">Register</button>
        <a href="${pageContext.request.contextPath}/vendor/login" class="btn">Already have an account? Login</a>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>

