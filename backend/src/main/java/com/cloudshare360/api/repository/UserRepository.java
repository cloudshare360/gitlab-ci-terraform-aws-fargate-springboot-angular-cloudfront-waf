package com.cloudshare360.api.repository;

import com.cloudshare360.api.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByEmail(String email);
    
    List<User> findByDepartment(String department);
    
    List<User> findByNameContainingIgnoreCase(String name);
    
    boolean existsByEmail(String email);
}