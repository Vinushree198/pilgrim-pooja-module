package com.pooja.main.repository;

import com.pooja.main.entity.Cart;
import com.pooja.main.entity.Customer;
import com.pooja.main.entity.PoojaItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
    List<Cart> findByCustomer(Customer customer);
    List<Cart> findByCustomerAndStatus(Customer customer, Cart.CartStatus status);
    Optional<Cart> findByCustomerAndItemAndStatus(Customer customer, PoojaItem item, Cart.CartStatus status);
    @Query("SELECT c FROM Cart c WHERE c.status = 'ACTIVE' AND c.expiresAt < :now")
    List<Cart> findExpiredCarts(LocalDateTime now);
}

