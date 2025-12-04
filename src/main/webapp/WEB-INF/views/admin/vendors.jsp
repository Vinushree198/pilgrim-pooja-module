<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Vendor Management" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/admin/vendors">Vendors</a><a href="${pageContext.request.contextPath}/admin/items">Items</a><a href="${pageContext.request.contextPath}/admin/orders">Orders</a><a href="${pageContext.request.contextPath}/admin/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>All Vendors</h2>
    <a href="${pageContext.request.contextPath}/admin/vendors/pending" class="btn btn-success">View Pending Vendors</a>
    
    <c:if test="${not empty vendors}">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Business Name</th>
                    <th>Owner Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Status</th>
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
                        <td>
                            <c:choose>
                                <c:when test="${vendor.status == 'PENDING'}">
                                    <span style="color: #f39c12;">PENDING</span>
                                </c:when>
                                <c:when test="${vendor.status == 'APPROVED'}">
                                    <span style="color: #27ae60;">APPROVED</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #e74c3c;">REJECTED</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${vendor.registeredAt}</td>
                        <td>
                            <c:if test="${vendor.status == 'PENDING'}">
                                <form action="${pageContext.request.contextPath}/admin/vendors/approve/${vendor.id}" method="post" style="display: inline;">
                                    <button type="submit" class="btn btn-success">Approve</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/vendors/reject/${vendor.id}" method="post" style="display: inline;">
                                    <button type="submit" class="btn btn-danger">Reject</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty vendors}">
        <p>No vendors found.</p>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>

