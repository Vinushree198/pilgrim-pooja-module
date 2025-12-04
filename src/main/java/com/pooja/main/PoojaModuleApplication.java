package com.pooja.main;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class PoojaModuleApplication {

	public static void main(String[] args) {
		SpringApplication.run(PoojaModuleApplication.class, args);
		System.out.println("Hi");
	}

}
