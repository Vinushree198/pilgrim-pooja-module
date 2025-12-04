<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Checkout" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/customer/items">Browse Items</a><a href="${pageContext.request.contextPath}/customer/cart">Cart</a><a href="${pageContext.request.contextPath}/customer/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Checkout</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <c:if test="${not empty cartItems}">
        <h3>Order Summary</h3>
        <table>
            <thead>
                <tr>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="total" value="0" />
                <c:forEach var="cartItem" items="${cartItems}">
                    <c:set var="subtotal" value="${cartItem.item.price * cartItem.quantity}" />
                    <c:set var="total" value="${total + subtotal}" />
                    <tr>
                        <td>${cartItem.item.name}</td>
                        <td>${cartItem.quantity}</td>
                        <td><fmt:formatNumber value="${cartItem.item.price}" type="currency" currencySymbol="₹"/></td>
                        <td><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="₹"/></td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="3" style="text-align: right;">Total:</th>
                    <th><fmt:formatNumber value="${total}" type="currency" currencySymbol="₹"/></th>
                </tr>
            </tfoot>
        </table>

        <h3 style="margin-top: 2rem;">Shipping Address</h3>
        <form action="${pageContext.request.contextPath}/customer/checkout" method="post">
            <div class="form-group">
                <label>Shipping Address *</label>
                <textarea name="shippingAddress" rows="4" required>${customer.address}</textarea>
            </div>

            <h3>Payment Method</h3>
            <div>
                <label><input type="radio" name="paymentMethod" value="COD" checked> Cash on Delivery</label>
                <label><input type="radio" name="paymentMethod" value="ONLINE"> Pay Online</label>
            </div>

            <button type="submit" class="btn btn-success" style="font-size: 1.2rem; padding: 1rem 2rem;">Place Order</button>
            <a href="${pageContext.request.contextPath}/customer/cart" class="btn">Back to Cart</a>
        </form>
    </c:if>

    <c:if test="${empty cartItems}">
        <p>Your cart is empty. <a href="${pageContext.request.contextPath}/customer/items">Browse items</a> to add to cart.</p>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>
