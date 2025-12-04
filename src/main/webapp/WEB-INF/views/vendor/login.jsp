<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Vendor Login" />
<%@ include file="../common/header.jsp" %>

<div class="card" style="max-width: 400px; margin: 2rem auto;">
    <h2>Vendor Login</h2>
    
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/vendor/login" method="post">
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>
        
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>
        
        <button type="submit" class="btn btn-primary" style="width: 100%;">Login</button>
        <a href="${pageContext.request.contextPath}/vendor/register" class="btn" style="width: 100%; text-align: center; display: block; margin-top: 1rem;">New Vendor? Register</a>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>

