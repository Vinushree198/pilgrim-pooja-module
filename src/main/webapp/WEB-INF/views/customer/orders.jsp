<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="My Orders" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a>
<a href="${pageContext.request.contextPath}/customer/items">Browse Items</a>
<a href="${pageContext.request.contextPath}/customer/cart">Cart</a>
<a href="${pageContext.request.contextPath}/customer/orders">Orders</a>
<a href="${pageContext.request.contextPath}/customer/logout">Logout</a>' />

<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>My Orders</h2>

    <c:if test="${not empty orders}">
        <table>
            <thead>
                <tr>
                    <th>Order Number</th>
                    <th>Item</th>
                    <th>Vendor</th>
                    <th>Quantity</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Order Date</th>
                    <th>Cancel Reason</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>${order.orderNumber}</td>
                        <td>${order.item.name}</td>
                        <td>${order.vendor.businessName}</td>
                        <td>${order.quantity}</td>
                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₹"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}">
                                    <span style="color: #f39c12;">PENDING</span>
                                </c:when>
                                <c:when test="${order.status == 'CONFIRMED'}">
                                    <span style="color: #3498db;">CONFIRMED</span>
                                </c:when>
                                <c:when test="${order.status == 'SHIPPED'}">
                                    <span style="color: #9b59b6;">SHIPPED</span>
                                </c:when>
                                <c:when test="${order.status == 'DELIVERED'}">
                                    <span style="color: #27ae60;">DELIVERED</span>
                                </c:when>
                                <c:when test="${order.status == 'CANCELLED'}">
                                    <span style="color: #e74c3c;">CANCELLED</span>
                                </c:when>
                                <c:otherwise>
                                    <span>UNKNOWN</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${order.createdAt}</td>
                        <td>
                            <c:if test="${order.status == 'CANCELLED'}">
                                ${order.cancelReason}
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${order.status == 'PENDING' || order.status == 'CONFIRMED'}">
                                <button type="button" class="btn-cancel" 
                                        data-order="${order.orderNumber}" 
                                        style="background:red;color:white;padding:5px;">
                                    Cancel
                                </button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty orders}">
        <p>You have no orders yet. <a href="${pageContext.request.contextPath}/customer/items">Browse items</a> to place an order.</p>
    </c:if>
</div>

<!-- ================= Cancel Modal ================= -->
<div id="cancelModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
     background: rgba(0,0,0,0.5); justify-content:center; align-items:center;">
    <div style="background:white; padding:20px; border-radius:8px; width:300px;">
        <h3>Cancel Order</h3>
        <form id="cancelForm" method="post">
            <input type="hidden" name="orderNumber" id="modalOrderNumber"/>
            <label>Reason for cancellation:</label>
            <textarea name="reason" rows="3" required></textarea>
            <br/><br/>
            <button type="submit" style="background:red;color:white;padding:5px;">Submit</button>
            <button type="button" id="closeModal" style="padding:5px;">Close</button>
        </form>
    </div>
</div>

<script>
    const modal = document.getElementById('cancelModal');
    const closeModal = document.getElementById('closeModal');
    const orderButtons = document.querySelectorAll('.btn-cancel');
    const modalOrderNumber = document.getElementById('modalOrderNumber');
    const cancelForm = document.getElementById('cancelForm');

    orderButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            modal.style.display = 'flex';
            modalOrderNumber.value = btn.getAttribute('data-order');
            cancelForm.action = '${pageContext.request.contextPath}/customer/orders/cancel/' + modalOrderNumber.value;
        });
    });

    closeModal.addEventListener('click', () => {
        modal.style.display = 'none';
    });
</script>

<%@ include file="../common/footer.jsp" %>
