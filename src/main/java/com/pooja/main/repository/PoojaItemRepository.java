package com.pooja.main.repository;

import com.pooja.main.entity.PoojaItem;
import com.pooja.main.entity.Vendor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PoojaItemRepository extends JpaRepository<PoojaItem, Long> {
    List<PoojaItem> findByVendor(Vendor vendor);
    List<PoojaItem> findByStatus(PoojaItem.ItemStatus status);
    List<PoojaItem> findByVendorAndStatus(Vendor vendor, PoojaItem.ItemStatus status);
    List<PoojaItem> findByStatusAndStockGreaterThan(PoojaItem.ItemStatus status, Integer stock);
    List<PoojaItem> findByCategory(String category);
    
    @Query("SELECT DISTINCT p.category FROM PoojaItem p WHERE p.status = 'ACTIVE' AND p.stock > 0")
    List<String> findAllCategories();

    @Query("""
        SELECT p FROM PoojaItem p
        WHERE p.status = 'ACTIVE' AND p.stock > 0
          AND (:search IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', :search, '%')))
          AND (:category IS NULL OR :category = '' OR p.category = :category)
        """)
    List<PoojaItem> filterItems(@Param("search") String search,
                                @Param("category") String category);
}

