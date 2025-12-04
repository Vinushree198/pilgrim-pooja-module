package com.pooja.main.controller;

import com.pooja.main.entity.PoojaItem;
import com.pooja.main.entity.Vendor;
import com.pooja.main.service.PoojaItemService;
import com.pooja.main.service.VendorService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Controller
@RequestMapping("/vendor")
public class VendorController {

    @Autowired
    private VendorService vendorService;

    @Autowired
    private PoojaItemService poojaItemService;

    private static final String UPLOAD_DIR = "uploads/";

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("vendor", new Vendor());
        return "vendor/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute Vendor vendor, Model model) {
        try {
            vendorService.registerVendor(vendor);
            model.addAttribute("success", "Registration successful! Please wait for admin approval.");
            return "vendor/register";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "vendor/register";
        }
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "vendor/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email, @RequestParam String password,
                       HttpSession session, Model model) {
        try {
            var vendorOpt = vendorService.login(email, password);
            if (vendorOpt.isPresent()) {
                session.setAttribute("vendor", vendorOpt.get());
                return "redirect:/vendor/dashboard";
            } else {
                model.addAttribute("error", "Invalid credentials or account not approved");
                return "vendor/login";
            }
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "vendor/login";
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Vendor vendor = (Vendor) session.getAttribute("vendor");
        if (vendor == null) {
            return "redirect:/vendor/login";
        }
        List<PoojaItem> items = poojaItemService.getVendorItems(vendor.getId());
        model.addAttribute("vendor", vendor);
        model.addAttribute("items", items);
        return "vendor/dashboard";
    }

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        Vendor vendor = (Vendor) session.getAttribute("vendor");
        if (vendor == null) {
            return "redirect:/vendor/login";
        }
        model.addAttribute("vendor", vendor);
        return "vendor/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute Vendor vendorDetails, HttpSession session) {
        Vendor vendor = (Vendor) session.getAttribute("vendor");
        if (vendor == null) {
            return "redirect:/vendor/login";
        }
        Vendor updated = vendorService.updateVendor(vendor.getId(), vendorDetails);
        session.setAttribute("vendor", updated);
        return "redirect:/vendor/profile";
    }

    @GetMapping("/change-password")
    public String showChangePassword() {
        return "vendor/change-password";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam String oldPassword, @RequestParam String newPassword,
                                HttpSession session, Model model) {
        Vendor vendor = (Vendor) session.getAttribute("vendor");
        if (vendor == null) {
            return "redirect:/vendor/login";
        }
        try {
            Vendor updated = vendorService.changePassword(vendor.getId(), oldPassword, newPassword);
            session.setAttribute("vendor", updated);
            model.addAttribute("success", "Password changed successfully");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        return "vendor/change-password";
    }

    @GetMapping("/items")
    public String listItems(HttpSession session, Model model) {
        Vendor vendor = (Vendor) session.getAttribute("vendor");
        if (vendor == null) {
            return "redirect:/vendor/login";
        }
        List<PoojaItem> items = poojaItemService.getVendorItems(vendor.getId());
        model.addAttribute("items", items);
        return "vendor/items";
    }

    @GetMapping("/items/add")
    public String showAddItemForm(Model model) {
        model.addAttribute("item", new PoojaItem());
        return "vendor/add-item";
    }

    @PostMapping("/items/add")
    public String addItem(@ModelAttribute PoojaItem item, @RequestParam("imageFile") MultipartFile imageFile,
                         HttpSession session, Model model) {
        Vendor vendor = (Vendor) session.getAttribute("vendor");
        if (vendor == null) {
            return "redirect:/vendor/login";
        }
        try {
            if (!imageFile.isEmpty()) {
                String fileName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                Path uploadPath = Paths.get(UPLOAD_DIR);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                Files.copy(imageFile.getInputStream(), uploadPath.resolve(fileName));
                item.setImagePath("/uploads/" + fileName);
            }
            poojaItemService.addItem(vendor.getId(), item);
            return "redirect:/vendor/items";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "vendor/add-item";
        }
    }

    @GetMapping("/items/edit/{id}")
    public String showEditItemForm(@PathVariable Long id, HttpSession session, Model model) {
        Vendor vendor = (Vendor) session.getAttribute("vendor");
        if (vendor == null) {
            return "redirect:/vendor/login";
        }
        var itemOpt = poojaItemService.getItemById(id);
        if (itemOpt.isPresent() && itemOpt.get().getVendor().getId().equals(vendor.getId())) {
            model.addAttribute("item", itemOpt.get());
            return "vendor/edit-item";
        }
        return "redirect:/vendor/items";
    }

    @PostMapping("/items/edit/{id}")
    public String updateItem(@PathVariable Long id, @ModelAttribute PoojaItem itemDetails,
                            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                            HttpSession session, Model model) {
        Vendor vendor = (Vendor) session.getAttribute("vendor");
        if (vendor == null) {
            return "redirect:/vendor/login";
        }
        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                String fileName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
                Path uploadPath = Paths.get(UPLOAD_DIR);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                Files.copy(imageFile.getInputStream(), uploadPath.resolve(fileName));
                itemDetails.setImagePath("/uploads/" + fileName);
            }
            poojaItemService.updateItem(id, itemDetails);
            return "redirect:/vendor/items";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "vendor/edit-item";
        }
    }

    @GetMapping("/items/delete/{id}")
    public String deleteItem(@PathVariable Long id, HttpSession session) {
        Vendor vendor = (Vendor) session.getAttribute("vendor");
        if (vendor == null) {
            return "redirect:/vendor/login";
        }
        poojaItemService.deleteItem(id);
        return "redirect:/vendor/items";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/vendor/login";
    }
}

