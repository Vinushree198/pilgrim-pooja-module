<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Change Password" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/vendor/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/vendor/profile">Profile</a><a href="${pageContext.request.contextPath}/vendor/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Change Password</h2>
    
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    
    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/vendor/change-password" method="post">
        <div class="form-group">
            <label>Old Password</label>
            <input type="password" name="oldPassword" required>
        </div>
        
        <div class="form-group">
            <label>New Password</label>
            <input type="password" name="newPassword" required>
        </div>
        
        <button type="submit" class="btn btn-primary">Change Password</button>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>

