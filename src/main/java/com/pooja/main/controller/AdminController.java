package com.pooja.main.controller;

import com.pooja.main.entity.Admin;
import com.pooja.main.entity.Order;
import com.pooja.main.entity.PoojaItem;
import com.pooja.main.entity.Vendor;
import com.pooja.main.service.AdminService;
import com.pooja.main.service.OrderService;
import com.pooja.main.service.PoojaItemService;
import com.pooja.main.service.VendorService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private VendorService vendorService;

    @Autowired
    private PoojaItemService poojaItemService;

    @Autowired
    private OrderService orderService;

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("admin", new Admin());
        return "admin/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute Admin admin, Model model) {
        try {
            adminService.createAdmin(admin);
            model.addAttribute("success", "Admin registration successful! Please login.");
            return "admin/register";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "admin/register";
        }
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "admin/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email, @RequestParam String password,
                       HttpSession session, Model model) {
        try {
            var adminOpt = adminService.login(email, password);
            if (adminOpt.isPresent()) {
                session.setAttribute("admin", adminOpt.get());
                return "redirect:/admin/dashboard";
            } else {
                model.addAttribute("error", "Invalid credentials");
                return "admin/login";
            }
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "admin/login";
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        
        List<Vendor> pendingVendors = vendorService.getPendingVendors();
        List<PoojaItem> allItems = poojaItemService.getAllItems();
        List<Order> allOrders = orderService.getAllOrders();
        
        model.addAttribute("pendingVendorsCount", pendingVendors.size());
        model.addAttribute("totalItems", allItems.size());
        model.addAttribute("totalOrders", allOrders.size());
        model.addAttribute("admin", admin);
        
        return "admin/dashboard";
    }

    @GetMapping("/vendors")
    public String listVendors(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        List<Vendor> vendors = vendorService.getAllVendors();
        model.addAttribute("vendors", vendors);
        return "admin/vendors";
    }

    @GetMapping("/vendors/pending")
    public String listPendingVendors(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        List<Vendor> pendingVendors = vendorService.getPendingVendors();
        model.addAttribute("vendors", pendingVendors);
        return "admin/pending-vendors";
    }

    @PostMapping("/vendors/approve/{id}")
    public String approveVendor(@PathVariable Long id, HttpSession session) {
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        vendorService.approveVendor(id);
        return "redirect:/admin/vendors/pending";
    }

    @PostMapping("/vendors/reject/{id}")
    public String rejectVendor(@PathVariable Long id, HttpSession session) {
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        vendorService.rejectVendor(id);
        return "redirect:/admin/vendors/pending";
    }

    @GetMapping("/items")
    public String listItems(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        List<PoojaItem> items = poojaItemService.getAllItems();
        model.addAttribute("items", items);
        return "admin/items";
    }

    @PostMapping("/items/block/{id}")
    public String blockItem(@PathVariable Long id, HttpSession session) {
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        var itemOpt = poojaItemService.getItemById(id);
        if (itemOpt.isPresent()) {
            PoojaItem item = itemOpt.get();
            item.setStatus(PoojaItem.ItemStatus.BLOCKED);
            poojaItemService.updateItem(id, item);
        }
        return "redirect:/admin/items";
    }

    @GetMapping("/orders")
    public String listOrders(HttpSession session, Model model) {
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        List<Order> orders = orderService.getAllOrders();
        model.addAttribute("orders", orders);
        return "admin/orders";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/admin/login";
    }
}

