package com.pooja.main.controller;

import com.pooja.main.entity.Cart;
import com.pooja.main.entity.Customer;
import com.pooja.main.entity.Order;
import com.pooja.main.entity.PoojaItem;
import com.pooja.main.service.CartService;
import com.pooja.main.service.CustomerService;
import com.pooja.main.service.OrderService;
import com.pooja.main.service.PoojaItemService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private PoojaItemService poojaItemService;

    @Autowired
    private CartService cartService;

    @Autowired
    private OrderService orderService;

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("customer", new Customer());
        return "customer/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute Customer customer, Model model) {
        try {
            customerService.registerCustomer(customer);
            model.addAttribute("success", "Registration successful! Please login.");
            return "customer/register";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "customer/register";
        }
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "customer/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email, @RequestParam String password,
                       HttpSession session, Model model) {
        try {
            var customerOpt = customerService.login(email, password);
            if (customerOpt.isPresent()) {
                session.setAttribute("customer", customerOpt.get());
                return "redirect:/customer/dashboard";
            } else {
                model.addAttribute("error", "Invalid credentials");
                return "customer/login";
            }
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "customer/login";
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }
        List<PoojaItem> items = poojaItemService.getAllActiveItems();
        model.addAttribute("items", items);
        model.addAttribute("customer", customer);
        return "customer/dashboard";
    }

  
    @GetMapping("/items")
    public String browseItems(HttpSession session, 
                              @RequestParam(required = false) String search,
                              @RequestParam(required = false) String category,
                              @RequestParam(required = false) String sort,
                              Model model) {

        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }

        // 🔥 Call service for filtered items
        List<PoojaItem> items = poojaItemService.advancedSearch(search, category, sort);

        // 🔥 Get all categories for dropdown
        List<String> categories = poojaItemService.getAllCategories();

        // Pass to JSP
        model.addAttribute("items", items);
        model.addAttribute("categories", categories);

        // Maintain inputs after refresh
        model.addAttribute("search", search);
        model.addAttribute("category", category);
        model.addAttribute("sort", sort);

        return "customer/items";
    }

    @GetMapping("/items/{id}")
    public String viewItem(@PathVariable Long id, HttpSession session, Model model) {
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }
        var itemOpt = poojaItemService.getItemById(id);
        if (itemOpt.isPresent()) {
            model.addAttribute("item", itemOpt.get());
            return "customer/item-details";
        }
        return "redirect:/customer/items";
    }

    @PostMapping("/cart/add")
    public String addToCart(@RequestParam Long itemId, @RequestParam Integer quantity,
                           HttpSession session, Model model) {
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }
        try {
            cartService.addToCart(customer.getId(), itemId, quantity);
            return "redirect:/customer/cart";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/customer/items";
        }
    }

    @GetMapping("/cart")
    public String viewCart(HttpSession session, Model model) {
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }
        List<Cart> cartItems = cartService.getCustomerCart(customer.getId());
        model.addAttribute("cartItems", cartItems);
        return "customer/cart";
    }

    @PostMapping("/cart/update/{id}")
    public String updateCartQuantity(@PathVariable Long id, @RequestParam Integer quantity,
                                     HttpSession session) {
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }
        try {
            cartService.updateCartQuantity(id, quantity);
        } catch (Exception e) {
            // Handle error
        }
        return "redirect:/customer/cart";
    }

    @PostMapping("/cart/remove/{id}")
    public String removeFromCart(@PathVariable Long id, HttpSession session) {
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }
        cartService.removeFromCart(id);
        return "redirect:/customer/cart";
    }

    @GetMapping("/checkout")
    public String showCheckout(HttpSession session, Model model) {
        // 1. Get customer from session
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }

        // 2. Get cart items for this customer
        List<Cart> cartItems = cartService.getCustomerCart(customer.getId());
        if (cartItems.isEmpty()) {
            return "redirect:/customer/cart";
        }

        // 3. Calculate total amount
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Cart cartItem : cartItems) {
            BigDecimal subtotal = cartItem.getItem().getPrice().multiply(new BigDecimal(cartItem.getQuantity()));
            totalAmount = totalAmount.add(subtotal);
        }

        // 4. Add attributes to model
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("totalAmount", totalAmount);
        model.addAttribute("customer", customer);

        // 5. Return checkout JSP
        return "customer/checkout";
    }


 // ======================= PLACE ORDER (COD / ONLINE) ===========================
 /*  @PostMapping("/checkout")
    public String placeOrder(@RequestParam String shippingAddress,
                             @RequestParam String paymentMethod,
                             HttpSession session, Model model) {

        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) return "redirect:/customer/login";

        session.setAttribute("shippingAddress", shippingAddress);

        // ***** If ONLINE PAYMENT selected *****
        if (paymentMethod.equalsIgnoreCase("ONLINE")) {
            Order order = orderService.createOrder(customer.getId(), shippingAddress, Order.PaymentMethod.ONLINE);

            // redirect to payment UI and pass orderId
            return "redirect:/customer/payment?orderId=" + order.getOrderNumber();
        }

        // ***** COD *****
        Order order = orderService.createOrder(customer.getId(), shippingAddress, Order.PaymentMethod.COD);
        cartService.clearCart(customer.getId());

        model.addAttribute("success", "Order placed successfully! Order No: " + order.getOrderNumber());
        return "customer/order-success";
    }
*/
    @PostMapping("/checkout")
    public String placeOrder(@RequestParam String address,
                             @RequestParam String city,
                             @RequestParam String state,
                             @RequestParam String paymentMethod,
                             HttpSession session, Model model) {

        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) return "redirect:/customer/login";

        List<Cart> cartItems = cartService.getCustomerCart(customer.getId());

        if (cartItems.isEmpty()) {
            model.addAttribute("errorMsg", "Your cart is empty.");
            return "customer/checkout";
        }

        // Check delivery locations
        boolean allItemsAvailable = true;
        StringBuilder unavailableItems = new StringBuilder();
        
        // Default expected delivery date
        java.time.LocalDate localExpectedDate = java.time.LocalDate.now();

        for (Cart cart : cartItems) {
            PoojaItem item = cart.getItem();
            String allowedLocations = item.getDeliveryStates(); // e.g., "Karnataka,Bangalore"
            if (allowedLocations == null || allowedLocations.isEmpty()) {
                allowedLocations = "Karnataka,Bangalore"; // default if null
            }

            String[] allowed = allowedLocations.split(",");
            boolean available = false;
            for (String loc : allowed) {
                if (loc.equalsIgnoreCase(city) || loc.equalsIgnoreCase(state)) {
                    available = true;
                    break;
                }
            }

            if (!available) {
                allItemsAvailable = false;
                unavailableItems.append(item.getName()).append(", ");
            }

            // Calculate expected delivery date (pick the max delay if multiple items)
            java.time.LocalDate itemExpectedDate;
            if (city.equalsIgnoreCase("Bangalore")) {
                itemExpectedDate = java.time.LocalDate.now().plusDays(2);
            } else if (state.equalsIgnoreCase("Karnataka")) {
                itemExpectedDate = java.time.LocalDate.now().plusDays(5);
            } else {
                itemExpectedDate = java.time.LocalDate.now().plusDays(7);
            }

            if (itemExpectedDate.isAfter(localExpectedDate)) {
                localExpectedDate = itemExpectedDate;
            }
        }

        // Convert LocalDate to java.util.Date for JSP
        java.util.Date expectedDate = java.util.Date.from(
                localExpectedDate.atStartOfDay(java.time.ZoneId.systemDefault()).toInstant()
        );

        if (!allItemsAvailable) {
            model.addAttribute("errorMsg", "Item(s) not available for this location: " +
                    unavailableItems.toString() + "Allowed locations: Bangalore/Karnataka");
            model.addAttribute("expectedDate", expectedDate);
            model.addAttribute("cartItems", cartItems);
            return "customer/checkout"; // return to checkout page
        }

        String fullAddress = address + ", " + city + ", " + state;
        session.setAttribute("shippingAddress", fullAddress);

        // Online payment
        if (paymentMethod.equalsIgnoreCase("ONLINE")) {
            session.setAttribute("expectedDate", expectedDate);
            Order order = orderService.createOrder(customer.getId(), fullAddress, Order.PaymentMethod.ONLINE);
            return "redirect:/customer/payment?orderId=" + order.getOrderNumber();
        }

        // COD
      /*  Order order = orderService.createOrder(customer.getId(), fullAddress, Order.PaymentMethod.COD);
        cartService.clearCart(customer.getId());

        model.addAttribute("success", "Order placed successfully! Order No: " + order.getOrderNumber());
        model.addAttribute("expectedDate", expectedDate);

        return "customer/order-success";
    }*/
     // COD
        Order order = orderService.createOrder(customer.getId(), fullAddress, Order.PaymentMethod.COD);
        cartService.clearCart(customer.getId());

        // store expected date in session
        session.setAttribute("expectedDate", expectedDate);

        return "redirect:/customer/order-success?order=" + order.getOrderNumber();
    }

    
    // ======================= LOAD PAYMENT PAGE ===========================
    @GetMapping("/payment")
    public String paymentPage(@RequestParam String orderId, Model model) {
        Order order = orderService.getOrderByOrderNumber(orderId);
        model.addAttribute("order", order);
        return "payment/onlinePayment";    // folder payment/onlinePayment.jsp
    }


    // ======================= PROCESS PAYMENT BUTTON CLICK ===========================
    @PostMapping("/payment/submit")
    public String processPayment(@RequestParam String orderId,
                                 @RequestParam String status) {

        Order order = orderService.getOrderByOrderNumber(orderId);

        if (status.equalsIgnoreCase("SUCCESS")) {
            order.setStatus(Order.OrderStatus.CONFIRMED);
            order.setPaymentStatus(Order.PaymentStatus.PAID);
            order.setTransactionId("TXN-" + orderId);
        } else {
            order.setStatus(Order.OrderStatus.PENDING);
            order.setPaymentStatus(Order.PaymentStatus.FAILED);
            order.setTransactionId("FAILED-" + orderId);
        }

        orderService.updateOrder(order);
        return "redirect:/customer/order-success?order=" + orderId;
    }

   
 // Show online payment checkout page
    @GetMapping("/customer/checkout-page")
    public String checkoutPage(@RequestParam String order, Model model) {
        Order o = orderService.getOrderByOrderNumber(order);
        model.addAttribute("order", o);
        return "payment/checkout"; // create payment/checkout.jsp
    }

    // Handle payment callback (simulate success/failure)
    @PostMapping("/callback")
    public String paymentCallback(@RequestParam String orderId,
                                  @RequestParam String status,
                                  @RequestParam String transactionId) {
        Order order = orderService.getOrderByOrderNumber(orderId);

        if ("SUCCESS".equalsIgnoreCase(status)) {
            order.setStatus(Order.OrderStatus.CONFIRMED);
            order.setPaymentStatus(Order.PaymentStatus.PAID);
            order.setTransactionId(transactionId);
        } else {
            order.setStatus(Order.OrderStatus.PENDING);
            order.setPaymentStatus(Order.PaymentStatus.FAILED);
        }

        orderService.updateOrder(order);

        return "redirect:/customer/order-success?order=" + orderId;
    }
    @GetMapping("/orders")
    public String viewOrders(HttpSession session, Model model) {
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }
        List<Order> orders = orderService.getCustomerOrders(customer.getId());
        model.addAttribute("orders", orders);
        return "customer/orders";
    }

    @GetMapping("/order-success")
    public String orderSuccess(@RequestParam("order") String orderNumber,
                               Model model,
                               HttpSession session) {   // <-- Added here

        Order orderDetails = orderService.getOrderByOrderNumber(orderNumber);

        if (orderDetails == null) {
            model.addAttribute("msg", "Invalid Order Number!");
            return "errorPage"; 
        }

        model.addAttribute("order", orderDetails);

        // Retrieve expected delivery date stored during checkout
        Object expected = session.getAttribute("expectedDate");
        if (expected != null) {
            model.addAttribute("expectedDate", expected);
            session.removeAttribute("expectedDate"); // Clear after showing once
        }

        return "customer/order-success";
    }

    
//-----------------cancel order------------//
 // Cancel order with reason
    @PostMapping("/orders/cancel/{orderNumber}")
    public String cancelOrder(@PathVariable String orderNumber,
                              @RequestParam("reason") String reason,
                              HttpSession session) {

        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            return "redirect:/customer/login";
        }

        // Fetch the order
        Order order = orderService.getOrderByOrderNumber(orderNumber);

        // Only allow cancellation if order belongs to this customer and is not yet shipped/delivered
        if (order != null && order.getCustomer().getId().equals(customer.getId())
                && (order.getStatus() == Order.OrderStatus.PENDING
                || order.getStatus() == Order.OrderStatus.CONFIRMED)) {

            order.setStatus(Order.OrderStatus.CANCELLED);
            order.setCancelReason(reason);
            orderService.updateOrder(order);
        }

        // Redirect back to orders page
        return "redirect:/customer/orders";
    }

    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/customer/login";
    }
    
    
}

