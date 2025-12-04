package com.pooja.main.service;

import com.pooja.main.entity.Cart;
import com.pooja.main.entity.Customer;
import com.pooja.main.entity.Order;
import com.pooja.main.entity.Vendor;
import com.pooja.main.repository.CartRepository;
import com.pooja.main.repository.CustomerRepository;
import com.pooja.main.repository.OrderRepository;
import com.pooja.main.repository.VendorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private VendorRepository vendorRepository;

    @Autowired
    private CartService cartService;

    // ---------------- Create Order ----------------
    @Transactional
    public Order createOrder(Long customerId, String shippingAddress, Order.PaymentMethod paymentMethod) {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));

        List<Cart> cartItems = cartRepository.findByCustomerAndStatus(
                customer, Cart.CartStatus.ACTIVE);

        if (cartItems.isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        Order lastOrder = null;

        for (Cart cart : cartItems) {
            String orderNumber = "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            BigDecimal totalAmount = cart.getItem().getPrice()
                    .multiply(BigDecimal.valueOf(cart.getQuantity()));

            Order order = new Order();
            order.setOrderNumber(orderNumber);
            order.setCustomer(customer);
            order.setVendor(cart.getItem().getVendor());
            order.setItem(cart.getItem());
            order.setQuantity(cart.getQuantity());
            order.setTotalAmount(totalAmount);
            order.setShippingAddress(shippingAddress);
            order.setStatus(Order.OrderStatus.PENDING);
            order.setPaymentMethod(paymentMethod); // set payment method here

            lastOrder = orderRepository.save(order);
        }

        // Checkout cart (reserved → sold stock)
        cartService.checkoutCart(customerId);

        return lastOrder;
    }

    // ---------------- Get Customer Orders ----------------
    public List<Order> getCustomerOrders(Long customerId) {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
        return orderRepository.findByCustomer(customer);
    }

    // ---------------- Get Vendor Orders ----------------
    public List<Order> getVendorOrders(Long vendorId) {
        Vendor vendor = vendorRepository.findById(vendorId)
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        return orderRepository.findByVendor(vendor);
    }

    // ---------------- Get All Orders ----------------
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    // ---------------- Update Order Status ----------------
    public Order updateOrderStatus(Long orderId, Order.OrderStatus status) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        order.setStatus(status);
        order.setUpdatedAt(LocalDateTime.now());
        return orderRepository.save(order);
    }

    // ---------------- Get Order by Order Number ----------------
    public Order getOrderByOrderNumber(String orderNumber) {
        return orderRepository.findByOrderNumber(orderNumber)
                .orElseThrow(() -> new RuntimeException("Order not found"));
    }

    // ---------------- Update Entire Order ----------------
    public Order updateOrder(Order order) {
        order.setUpdatedAt(LocalDateTime.now());
        return orderRepository.save(order);
    }
}
