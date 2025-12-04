<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Customer Registration" />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Customer Registration</h2>
    
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/customer/register" method="post">
        <div class="form-group">
            <label>Name *</label>
            <input type="text" name="name" required>
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
            <label>Address *</label>
            <textarea name="address" rows="3" required></textarea>
        </div>
        
        <div class="form-group">
            <label>Password *</label>
            <input type="password" name="password" required>
        </div>
        
        <button type="submit" class="btn btn-primary">Register</button>
        <a href="${pageContext.request.contextPath}/customer/login" class="btn">Already have an account? Login</a>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>

