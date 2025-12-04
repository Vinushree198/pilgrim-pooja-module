<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Admin Registration" />
<%@ include file="../common/header.jsp" %>

<div class="card" style="max-width: 400px; margin: 2rem auto;">
    <h2>Admin Registration</h2>
    
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/admin/register" method="post">
        <div class="form-group">
            <label>Name *</label>
            <input type="text" name="name" required>
        </div>
        
        <div class="form-group">
            <label>Email *</label>
            <input type="email" name="email" required>
        </div>
        
        <div class="form-group">
            <label>Password *</label>
            <input type="password" name="password" required>
        </div>
        
        <button type="submit" class="btn btn-primary" style="width: 100%;">Register</button>
        <a href="${pageContext.request.contextPath}/admin/login" class="btn" style="width: 100%; text-align: center; display: block; margin-top: 1rem;">Already have an account? Login</a>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>

