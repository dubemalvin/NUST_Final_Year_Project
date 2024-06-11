package com.bebsc.BlockchainApplication.Dto;

import com.bebsc.BlockchainApplication.Entity.Users;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Data
@Setter
@Getter
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class UsersDto {
    private int statusCode;
    private String Error;
    private String message;
    private String token;
    private String refreshToken;
    private String expirationTime;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String address;
    private String role;
    private Users users;
    private List<Users> usersList;

}
