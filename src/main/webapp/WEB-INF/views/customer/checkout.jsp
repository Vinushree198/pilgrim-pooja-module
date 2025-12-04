<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Checkout" />
<%@ include file="../common/header.jsp" %>

<style>
    .checkout-container{
        max-width: 850px;
        margin: 30px auto;
        background: #fff;
        padding: 25px;
        border-radius: 8px;
        box-shadow: 0 0 12px rgba(0,0,0,0.1);
    }
    .checkout-container h2{font-size:28px; font-weight:600; margin-bottom:18px;text-align:center;}
    .SectionTitle{font-size:22px;font-weight:600;margin:15px 0;}
    table th, table td {padding:10px;text-align:center;}
    .form-group input{width:100%;padding:10px;font-size:16px;border-radius:6px;border:1px solid #ccc;}
    .payment-box{
        border:1px solid #ddd;
        border-radius:8px;
        padding:15px;
        margin-top:10px;
        background:#fafafa;
    }
    .payment-option{
        display:flex; align-items:center;
        border:1px solid #ccc;
        padding:12px;
        border-radius:6px;
        margin-bottom:10px;
        cursor:pointer;
        transition:0.3s;
    }
    .payment-option:hover{background:#e9f7e9;}
    .payment-option input{margin-right:10px; transform:scale(1.2);}
    .btn-place {background:#27ae60;color:white;border:none;padding:12px 25px;font-size:18px;border-radius:6px;}
    .btn-place:hover{background:#1e8449;}
    .btn-back{padding:12px 20px;border-radius:6px;font-size:15px;margin-left:10px;}
</style>

<div class="checkout-container">

    <h2>Checkout</h2>

    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger" style="padding:10px;margin-bottom:15px;font-size:16px;border-radius:6px;">
            ⚠ ${errorMsg}
        </div>
    </c:if>

    <c:if test="${not empty expectedDate}">
        <div class="alert alert-info" style="padding:10px;margin-bottom:15px;font-size:16px;border-radius:6px;">
            📅 Expected Delivery Date: 
            <b><fmt:formatDate value="${expectedDate}" pattern="dd MMM yyyy"/></b>
        </div>
    </c:if>

    <c:if test="${not empty cartItems}">
        <div>
            <h3 class="SectionTitle">Order Summary</h3>
            <table class="table table-bordered">
                <thead style="background:#f2f2f2;font-weight:bold;">
                    <tr>
                        <th>Item</th>
                        <th>Qty</th>
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
                            <td>₹${cartItem.item.price}</td>
                            <td>₹${subtotal}</td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot style="font-weight:bold;background:#f9f9f9;">
                    <tr>
                        <td colspan="3" style="text-align:right;">Total:</td>
                        <td>₹${total}</td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <h3 class="SectionTitle">Shipping Information</h3>
        <form action="${pageContext.request.contextPath}/customer/checkout" method="post">

            <div class="form-group" style="margin-bottom:12px;">
                <label>Address:</label>
                <input type="text" name="address" required>
            </div>

            <div class="form-group" style="margin-bottom:12px;">
                <label>City:</label>
                <input type="text" name="city" required>
            </div>

            <div class="form-group" style="margin-bottom:18px;">
                <label>State:</label>
                <input type="text" name="state" required>
            </div>

            <h3 class="SectionTitle">Payment Method</h3>
            <div class="payment-box">
                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="COD" checked>
                    💵 Cash on Delivery
                </label>

                <label class="payment-option">
                    <input type="radio" name="paymentMethod" value="ONLINE">
                    💳 Pay Online (UPI/Card/Netbanking)
                </label>
            </div>

            <div style="text-align:center;margin-top:25px;">
                <button type="submit" class="btn-place">Place Order</button>
                <a href="${pageContext.request.contextPath}/customer/cart" class="btn-back btn btn-secondary">Back to Cart</a>
            </div>
        </form>
    </c:if>

    <c:if test="${empty cartItems}">
        <p>Your cart is empty. <a href="${pageContext.request.contextPath}/customer/items">Browse items</a></p>
    </c:if>
</div>

<%@ include file="../common/footer.jsp" %>
