package com.pooja.main.service;

import com.pooja.main.entity.Vendor;
import com.pooja.main.repository.VendorRepository;
import com.pooja.main.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class VendorService {

    @Autowired
    private VendorRepository vendorRepository;

    @Autowired
    private EmailService emailService;

    public Vendor registerVendor(Vendor vendor) {
        if (vendorRepository.existsByEmail(vendor.getEmail())) {
            throw new RuntimeException("Email already exists");
        }
        vendor.setPassword(PasswordUtil.encode(vendor.getPassword()));
        vendor.setStatus(Vendor.VendorStatus.PENDING);
        Vendor savedVendor = vendorRepository.save(vendor);
        
        // Notify admin (in real scenario, get admin email from config)
        emailService.sendNewVendorNotification("admin@pooja.com", savedVendor.getBusinessName());
        
        return savedVendor;
    }

    public Optional<Vendor> login(String email, String password) {
        Optional<Vendor> vendorOpt = vendorRepository.findByEmail(email);
        if (vendorOpt.isPresent()) {
            Vendor vendor = vendorOpt.get();
            if (PasswordUtil.matches(password, vendor.getPassword())) {
                if (vendor.getStatus() == Vendor.VendorStatus.APPROVED) {
                    return Optional.of(vendor);
                }
            }
        }
        return Optional.empty();
    }

    public List<Vendor> getPendingVendors() {
        return vendorRepository.findByStatus(Vendor.VendorStatus.PENDING);
    }

    public List<Vendor> getAllVendors() {
        return vendorRepository.findAll();
    }

    public Optional<Vendor> getVendorById(Long id) {
        return vendorRepository.findById(id);
    }

    public Vendor approveVendor(Long id) {
        Vendor vendor = vendorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        vendor.setStatus(Vendor.VendorStatus.APPROVED);
        Vendor updated = vendorRepository.save(vendor);
        emailService.sendVendorApprovalEmail(updated.getEmail(), updated.getOwnerName());
        return updated;
    }

    public Vendor rejectVendor(Long id) {
        Vendor vendor = vendorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        vendor.setStatus(Vendor.VendorStatus.REJECTED);
        Vendor updated = vendorRepository.save(vendor);
        emailService.sendVendorRejectionEmail(updated.getEmail(), updated.getOwnerName());
        return updated;
    }

    public Vendor updateVendor(Long id, Vendor vendorDetails) {
        Vendor vendor = vendorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        vendor.setOwnerName(vendorDetails.getOwnerName());
        vendor.setPhone(vendorDetails.getPhone());
        vendor.setBusinessName(vendorDetails.getBusinessName());
        vendor.setBusinessType(vendorDetails.getBusinessType());
        vendor.setAddress(vendorDetails.getAddress());
        return vendorRepository.save(vendor);
    }

    public Vendor changePassword(Long id, String oldPassword, String newPassword) {
        Vendor vendor = vendorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vendor not found"));
        if (!PasswordUtil.matches(oldPassword, vendor.getPassword())) {
            throw new RuntimeException("Old password is incorrect");
        }
        vendor.setPassword(PasswordUtil.encode(newPassword));
        return vendorRepository.save(vendor);
    }
}

