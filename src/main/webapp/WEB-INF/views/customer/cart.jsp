<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Shopping Cart" />
<c:set var="navLinks" value='<a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a><a href="${pageContext.request.contextPath}/customer/items">Browse Items</a><a href="${pageContext.request.contextPath}/customer/cart">Cart</a><a href="${pageContext.request.contextPath}/customer/orders">Orders</a><a href="${pageContext.request.contextPath}/customer/logout">Logout</a>' />
<%@ include file="../common/header.jsp" %>

<div class="card">
    <h2>Shopping Cart</h2>
    
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    
    <c:if test="${not empty cartItems}">
        <table>
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Item Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="total" value="0" />
                <c:forEach var="cartItem" items="${cartItems}">
                    <c:set var="subtotal" value="${cartItem.item.price * cartItem.quantity}" />
                    <c:set var="total" value="${total + subtotal}" />
                    <tr>
                        <td>
                            <c:if test="${not empty cartItem.item.imagePath}">
                                <img src="${pageContext.request.contextPath}${cartItem.item.imagePath}" alt="${cartItem.item.name}" style="width: 50px; height: 50px; object-fit: cover;">
                            </c:if>
                        </td>
                        <td>${cartItem.item.name}</td>
                        <td><fmt:formatNumber value="${cartItem.item.price}" type="currency" currencySymbol="₹"/></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/customer/cart/update/${cartItem.id}" method="post" style="display: inline;">
                                <input type="number" name="quantity" value="${cartItem.quantity}" min="1" max="${cartItem.item.stock + cartItem.quantity}" style="width: 60px;">
                                <button type="submit" class="btn btn-primary">Update</button>
                            </form>
                        </td>
                        <td><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="₹"/></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/customer/cart/remove/${cartItem.id}" method="post" style="display: inline;">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Remove from cart?')">Remove</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="4" style="text-align: right;">Total:</th>
                    <th><fmt:formatNumber value="${total}" type="currency" currencySymbol="₹"/></th>
                    <th></th>
                </tr>
            </tfoot>
        </table>
        
        <div style="margin-top: 1rem;">
            <a href="${pageContext.request.contextPath}/customer/checkout" class="btn btn-success" style="font-size: 1.2rem; padding: 1rem 2rem;">Proceed to Checkout</a>
        </div>
    </c:if>
    <c:if test="${empty cartItems}">
        <p>Your cart is empty. <a href="${pageContext.request.contextPath}/customer/items">Browse items</a> to add to cart.</p>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>

