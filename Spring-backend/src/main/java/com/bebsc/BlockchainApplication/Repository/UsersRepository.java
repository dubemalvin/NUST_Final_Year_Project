package com.bebsc.BlockchainApplication.Repository;

import com.bebsc.BlockchainApplication.Entity.Users;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UsersRepository extends JpaRepository<Users,Long> {
    Optional<Users> findByEmail(String email);
}
