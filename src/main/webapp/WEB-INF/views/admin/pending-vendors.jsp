<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Pending Vendors" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/admin/vendors">Vendors</a><a href="${pageContext.request.contextPath}/admin/items">Items</a><a href="${pageContext.request.contextPath}/admin/orders">Orders</a><a href="${pageContext.request.contextPath}/admin/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Pending Vendor Approvals</h2>
    <p style="color: #f39c12; font-weight: bold;">New Vendor Registered - Action Required</p>
    
    <c:if test="${not empty vendors}">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Business Name</th>
                    <th>Owner Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Business Type</th>
                    <th>Address</th>
                    <th>Registered At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="vendor" items="${vendors}">
                    <tr>
                        <td>${vendor.id}</td>
                        <td>${vendor.businessName}</td>
                        <td>${vendor.ownerName}</td>
                        <td>${vendor.email}</td>
                        <td>${vendor.phone}</td>
                        <td>${vendor.businessType}</td>
                        <td>${vendor.address}</td>
                        <td>${vendor.registeredAt}</td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/vendors/approve/${vendor.id}" method="post" style="display: inline;">
                                <button type="submit" class="btn btn-success">✓ Approve</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/admin/vendors/reject/${vendor.id}" method="post" style="display: inline;">
                                <button type="submit" class="btn btn-danger">✗ Reject</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty vendors}">
        <p>No pending vendors.</p>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>

