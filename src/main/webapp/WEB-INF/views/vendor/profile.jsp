<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Vendor Profile" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/vendor/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/vendor/profile">Profile</a><a href="${pageContext.request.contextPath}/vendor/change-password">Change Password</a><a href="${pageContext.request.contextPath}/vendor/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>My Profile</h2>
    
    <form action="${pageContext.request.contextPath}/vendor/profile/update" method="post">
        <div class="form-group">
            <label>Owner Name</label>
            <input type="text" name="ownerName" value="${vendor.ownerName}" required>
        </div>
        
        <div class="form-group">
            <label>Email</label>
            <input type="email" value="${vendor.email}" disabled>
        </div>
        
        <div class="form-group">
            <label>Phone</label>
            <input type="tel" name="phone" value="${vendor.phone}" required>
        </div>
        
        <div class="form-group">
            <label>Business Name</label>
            <input type="text" name="businessName" value="${vendor.businessName}" required>
        </div>
        
        <div class="form-group">
            <label>Business Type</label>
            <select name="businessType" required>
                <option value="Retail" ${vendor.businessType == 'Retail' ? 'selected' : ''}>Retail</option>
                <option value="Wholesale" ${vendor.businessType == 'Wholesale' ? 'selected' : ''}>Wholesale</option>
                <option value="Online" ${vendor.businessType == 'Online' ? 'selected' : ''}>Online</option>
                <option value="Other" ${vendor.businessType == 'Other' ? 'selected' : ''}>Other</option>
            </select>
        </div>
        
        <div class="form-group">
            <label>Address</label>
            <textarea name="address" rows="3" required>${vendor.address}</textarea>
        </div>
        
        <button type="submit" class="btn btn-primary">Update Profile</button>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>

