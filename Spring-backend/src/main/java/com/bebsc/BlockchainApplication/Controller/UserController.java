package com.bebsc.BlockchainApplication.Controller;

import com.bebsc.BlockchainApplication.Dto.UsersDto;
import com.bebsc.BlockchainApplication.Service.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
import java.util.stream.Collectors;

@RestController
@CrossOrigin("localHost:3000")
public class UserController {
    @Autowired
    private UsersService usersService;

    @PostMapping("/auth/register")
    public ResponseEntity<UsersDto> register(@RequestBody UsersDto usersDto){
        return ResponseEntity.ok(usersService.registerUsers(usersDto));
    }
    @GetMapping("/getAllUser")
    public ResponseEntity<UsersDto> getAllUsers(){
        return ResponseEntity.ok(usersService.getAllUsers());
    }
    @PostMapping("/auth/login")
    public ResponseEntity<UsersDto> login(@RequestBody UsersDto usersDto){
        return ResponseEntity.ok(usersService.loginRequest(usersDto));
    }
    @PostMapping("/auth/logout")
    public ResponseEntity<String> logout() {
        SecurityContextHolder.clearContext();
        return ResponseEntity.ok("Logout successful");
    }
}
