package com.bebsc.BlockchainApplication;


import com.bebsc.BlockchainApplication.Entity.Users;
import com.bebsc.BlockchainApplication.Repository.UsersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;


@Component
public class DataLoader implements CommandLineRunner {

    @Autowired
    private PasswordEncoder passwordEncoder;
    private final UsersRepository repo;

    public DataLoader(UsersRepository repo) {
        this.repo = repo;
    }

    @Override
    public void run(String... args) throws Exception {
        // Add sample data to the database
        addSampleUsers();
    }

    private void addSampleUsers() {
        Users admin = new Users();
        admin.setFirstName("admin");
        admin.setLastName("admin");
        admin.setEmail("admin@gmail.com");
        admin.setPassword(passwordEncoder.encode("welly"));
        admin.setRole("ADMIN");

        Users doctor = new Users();
        doctor.setFirstName("doctor");
        doctor.setLastName("doctor");
        doctor.setEmail("doctor@gmail.com");
        doctor.setPassword(passwordEncoder.encode("welly"));
        doctor.setRole("DOCTOR");

        Users nurse = new Users();
        nurse.setFirstName("nurse");
        nurse.setLastName("nurse");
        nurse.setEmail("nurse@gmail.com");
        nurse.setPassword(passwordEncoder.encode("welly"));
        nurse.setRole("NURSE");

        Users donor = new Users();
        donor.setFirstName("donor");
        donor.setLastName("donor");
        donor.setEmail("donor@gmail.com");
        donor.setPassword(passwordEncoder.encode("welly"));
        donor.setRole("DONOR");

        repo.save(admin);
        repo.save(doctor);
        repo.save(nurse);
        repo.save(donor);
    }
}

