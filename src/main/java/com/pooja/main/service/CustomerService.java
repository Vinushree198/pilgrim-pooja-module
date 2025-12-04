package com.pooja.main.service;

import com.pooja.main.entity.Customer;
import com.pooja.main.repository.CustomerRepository;
import com.pooja.main.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    public Customer registerCustomer(Customer customer) {
        if (customerRepository.existsByEmail(customer.getEmail())) {
            throw new RuntimeException("Email already exists");
        }
        customer.setPassword(PasswordUtil.encode(customer.getPassword()));
        return customerRepository.save(customer);
    }

    public Optional<Customer> login(String email, String password) {
        Optional<Customer> customerOpt = customerRepository.findByEmail(email);
        if (customerOpt.isPresent()) {
            Customer customer = customerOpt.get();
            if (PasswordUtil.matches(password, customer.getPassword())) {
                return Optional.of(customer);
            }
        }
        return Optional.empty();
    }

    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    public Optional<Customer> getCustomerById(Long id) {
        return customerRepository.findById(id);
    }

    public Customer updateCustomer(Long id, Customer customerDetails) {
        Customer customer = customerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
        customer.setName(customerDetails.getName());
        customer.setPhone(customerDetails.getPhone());
        customer.setAddress(customerDetails.getAddress());
        return customerRepository.save(customer);
    }

    public Customer changePassword(Long id, String oldPassword, String newPassword) {
        Customer customer = customerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Customer not found"));
        if (!PasswordUtil.matches(oldPassword, customer.getPassword())) {
            throw new RuntimeException("Old password is incorrect");
        }
        customer.setPassword(PasswordUtil.encode(newPassword));
        return customerRepository.save(customer);
    }
}

