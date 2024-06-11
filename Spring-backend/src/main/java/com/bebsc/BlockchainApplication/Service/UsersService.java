package com.bebsc.BlockchainApplication.Service;

import com.bebsc.BlockchainApplication.Dto.UsersDto;
import com.bebsc.BlockchainApplication.Entity.Users;
import com.bebsc.BlockchainApplication.Repository.UsersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Optional;

@Service
public class UsersService {

    @Autowired
    private JWTUtils jwtUtils;
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UsersRepository usersRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public UsersDto registerUsers(UsersDto request){
        UsersDto usersDto = new UsersDto();
        try {
            if(usersRepository.findByEmail(request.getEmail()).isPresent()) {
                throw new Exception("Email already exists");
            }

            Users users = new Users();
            users.setFirstName(request.getFirstName());
            users.setLastName(request.getLastName());
            users.setAddress(request.getAddress());
            users.setEmail(request.getEmail());
            users.setRole(request.getRole());
            users.setPassword(passwordEncoder.encode(request.getPassword()));
            Users users1 = usersRepository.save(users);
            if (users1.getUserId()>0) {
                request.setStatusCode(200);
                request.setMessage("success");
                request.setUsers(users1);
            }

        }catch (Exception e){
            request.setStatusCode(500);
            request.setMessage(e.getMessage());
        }
        return usersDto;
    }
    public UsersDto loginRequest(UsersDto request) {
        UsersDto response = new UsersDto();
        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));

            var user = usersRepository.findByEmail(request.getEmail()).orElseThrow(() -> new UsernameNotFoundException(request.getEmail() + " not found"));

            var jwt = jwtUtils.generateToken(user);
            var refreshToken = jwtUtils.generateRefreshToken(new HashMap<>(), user);

            // Populate additional user details in the response
            response.setFirstName(user.getFirstName());
            response.setLastName(user.getLastName());
            response.setRole(user.getRole());

            response.setStatusCode(200);
            response.setToken(jwt);
            response.setRefreshToken(refreshToken);
            response.setExpirationTime("24Hrs");
            response.setMessage("Login Success");
        } catch (Exception e) {
            response.setStatusCode(500);
            response.setMessage(e.getMessage());
        }
        return response;
    }

    public UsersDto refreshToken(UsersDto request){
        UsersDto response = new UsersDto();
        try {
            String email = jwtUtils.extractUsername(request.getToken());
            Users users = usersRepository.findByEmail(email).orElseThrow(()-> new UsernameNotFoundException(email+"not found"));
            if (jwtUtils.isTokenValid(request.getToken(), users)){
                var jwt = jwtUtils.generateToken(users);
                response.setStatusCode(200);
                response.setToken(jwt);
                response.setRefreshToken(request.getToken());
                response.setExpirationTime("24Hrs");
                response.setMessage("Successfully Refreshed Token");
            }
            response.setStatusCode(200);
        }catch (Exception e){
            response.setStatusCode(500);
            response.setMessage(e.getMessage());
        }
        return response;
    }
    public UsersDto getAllUsers(){
        UsersDto response = new UsersDto();

        try {
            List<Users> users = usersRepository.findAll();
            if (!users.isEmpty()) {
                response.setUsersList(users);
                response.setStatusCode(200);
                response.setMessage("success");
            }else{
                response.setMessage("failed");
                response.setStatusCode(404);
            }

        }catch (Exception e){
            response.setStatusCode(500);
            response.setMessage(e.getMessage());
        }
        return response;
    }

    public Optional<Users> getName(String email){
        return usersRepository.findByEmail(email);
    }
}
