package com.pooja.main.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    public void sendVendorApprovalEmail(String vendorEmail, String vendorName) {
        if (mailSender == null) {
            System.out.println("Email service not configured. Approval email would be sent to: " + vendorEmail);
            return;
        }

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(vendorEmail);
        message.setSubject("Vendor Account Approved");
        message.setText("Dear " + vendorName + ",\n\nYour vendor account has been approved. You can now log in to your dashboard.\n\nThank you!");
        mailSender.send(message);
    }

    public void sendVendorRejectionEmail(String vendorEmail, String vendorName) {
        if (mailSender == null) {
            System.out.println("Email service not configured. Rejection email would be sent to: " + vendorEmail);
            return;
        }

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(vendorEmail);
        message.setSubject("Vendor Account Rejected");
        message.setText("Dear " + vendorName + ",\n\nUnfortunately, your vendor account registration has been rejected. Please contact support for more information.\n\nThank you!");
        mailSender.send(message);
    }

    public void sendNewVendorNotification(String adminEmail, String vendorName) {
        if (mailSender == null) {
            System.out.println("Email service not configured. New vendor notification would be sent to: " + adminEmail);
            return;
        }

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(adminEmail);
        message.setSubject("New Vendor Registered");
        message.setText("A new vendor '" + vendorName + "' has registered and is pending approval.");
        mailSender.send(message);
    }
}

