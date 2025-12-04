package com.pooja.main.service;

import com.pooja.main.entity.Cart;
import com.pooja.main.entity.Customer;
import com.pooja.main.entity.PoojaItem;
import com.pooja.main.repository.CartRepository;
import com.pooja.main.repository.CustomerRepository;
import com.pooja.main.repository.PoojaItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private PoojaItemRepository poojaItemRepository;

    @Autowired
    private PoojaItemService poojaItemService;

    @Transactional
    public Cart addToCart(Long customerId, Long itemId, Integer quantity) {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
        PoojaItem item = poojaItemRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item not found"));

        if (item.getStock() < quantity) {
            throw new RuntimeException("Insufficient stock");
        }

        Optional<Cart> existingCart = cartRepository.findByCustomerAndItemAndStatus(
                customer, item, Cart.CartStatus.ACTIVE);

        if (existingCart.isPresent()) {
            Cart cart = existingCart.get();
            int newQuantity = cart.getQuantity() + quantity;
            int quantityDiff = quantity;
            
            // Release old reserved stock
            poojaItemService.releaseStock(itemId, cart.getQuantity());
            
            // Reserve new quantity
            poojaItemService.reserveStock(itemId, newQuantity);
            
            cart.setQuantity(newQuantity);
            cart.setUpdatedAt(LocalDateTime.now());
            cart.setExpiresAt(LocalDateTime.now().plusMinutes(30));
            return cartRepository.save(cart);
        } else {
            // Reserve stock
            poojaItemService.reserveStock(itemId, quantity);
            
            Cart cart = new Cart(customer, item, quantity);
            cart.setExpiresAt(LocalDateTime.now().plusMinutes(30));
            return cartRepository.save(cart);
        }
    }

    public List<Cart> getCustomerCart(Long customerId) {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
        return cartRepository.findByCustomerAndStatus(customer, Cart.CartStatus.ACTIVE);
    }

    @Transactional
    public Cart updateCartQuantity(Long cartId, Integer newQuantity) {
        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));
        
        PoojaItem item = cart.getItem();
        int quantityDiff = newQuantity - cart.getQuantity();
        
        if (quantityDiff > 0) {
            // Increase quantity
            if (item.getStock() < quantityDiff) {
                throw new RuntimeException("Insufficient stock");
            }
            poojaItemService.reserveStock(item.getId(), quantityDiff);
        } else if (quantityDiff < 0) {
            // Decrease quantity
            poojaItemService.releaseStock(item.getId(), Math.abs(quantityDiff));
        }
        
        cart.setQuantity(newQuantity);
        cart.setUpdatedAt(LocalDateTime.now());
        cart.setExpiresAt(LocalDateTime.now().plusMinutes(30));
        return cartRepository.save(cart);
    }

    @Transactional
    public void removeFromCart(Long cartId) {
        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));
        
        // Release reserved stock
        poojaItemService.releaseStock(cart.getItem().getId(), cart.getQuantity());
        
        cart.setStatus(Cart.CartStatus.REMOVED);
        cart.setUpdatedAt(LocalDateTime.now());
        cartRepository.save(cart);
    }

    @Transactional
    @Scheduled(fixedRate = 600000) // Run every 10 minutes
    public void restoreExpiredCarts() {
        List<Cart> expiredCarts = cartRepository.findExpiredCarts(LocalDateTime.now());
        for (Cart cart : expiredCarts) {
            if (cart.getStatus() == Cart.CartStatus.ACTIVE) {
                // Release reserved stock
                poojaItemService.releaseStock(cart.getItem().getId(), cart.getQuantity());
                cart.setStatus(Cart.CartStatus.EXPIRED);
                cartRepository.save(cart);
            }
        }
    }

    @Transactional
    public void checkoutCart(Long customerId) {
        List<Cart> cartItems = getCustomerCart(customerId);
        for (Cart cart : cartItems) {
            // Convert reserved stock to sold stock
            poojaItemService.convertReservedToSold(cart.getItem().getId(), cart.getQuantity());
            cart.setStatus(Cart.CartStatus.CHECKED_OUT);
            cart.setUpdatedAt(LocalDateTime.now());
            cartRepository.save(cart);
        }
    }

	

	public void clearCart(Long id) {
		// TODO Auto-generated method stub
		
	}
}

