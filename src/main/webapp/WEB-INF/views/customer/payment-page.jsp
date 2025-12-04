<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Online Payment</h2>
<p>Select Payment Method</p>

<form action="${pageContext.request.contextPath}/customer/process-payment" method="post">

    <label><input type="radio" name="method" value="UPI" checked> UPI</label><br>
    <div style="margin-left:20px;">
        <input type="text" name="upiId" placeholder="example@upi" required/><br><br>
    </div>

    <label><input type="radio" name="method" value="CARD"> Debit/Credit Card</label>
    <div style="margin-left:20px;">
        <input type="text" name="cardNumber" placeholder="Card Number"><br>
        <input type="text" name="nameOnCard" placeholder="Name on Card"><br>
        <input type="text" name="expiry" placeholder="MM/YY"><br>
        <input type="password" name="cvv" placeholder="CVV"><br><br>
    </div>

    <label><input type="radio" name="method" value="NETBANKING"> Net Banking</label><br><br>

    <button type="submit" class="btn btn-success">Pay Now</button>
    <a href="${pageContext.request.contextPath}/customer/checkout" class="btn">Cancel</a>
</form>
