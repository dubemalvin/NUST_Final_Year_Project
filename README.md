

# Full Stack Application with RBAC, React Frontend, and Ethereum Blockchain

This project consists of three main components:
1. A Spring Boot application for role-based access control (RBAC).
2. A React frontend application.
3. An Ethereum blockchain project using Hardhat.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Setup and Running Instructions](#setup-and-running-instructions)
    - [Spring Boot Application](#spring-boot-application)
    - [React Frontend](#react-frontend)
    - [Ethereum Blockchain with Hardhat](#ethereum-blockchain-with-hardhat)
3. [Data Loader for Spring Boot Application](#data-loader-for-spring-boot-application)

## Prerequisites
- Java 11 or higher
- Node.js and npm
- Docker (for running a local Ethereum node)
- Hardhat

## Setup and Running Instructions

### Spring Boot Application

1. **Clone the repository:**
    ```bash

    cd <repository-directory>/backend
    ```

2. **Configure the application:**
    - Create an `application.properties` file in the `src/main/resources` directory.
    - Add the necessary database configuration. there is a resource already
      

3. **Build and run the application:**
    ```bash
    ./mvnw clean install
    ./mvnw spring-boot:run
    ```

### React Frontend

1. **Navigate to the frontend directory:**
    ```bash
    cd <repository-directory>/frontend
    ```

2. **Install dependencies:**
    ```bash
    npm install
    ```

3. **Run the application:**
    ```bash
    npm start
    ```

4. **Open your browser and navigate to:**
    ```
    http://localhost:3000
    ```

### Ethereum Blockchain with Hardhat

1. **Navigate to the blockchain directory:**
    ```bash
    cd <repository-directory>/blockchain
    ```

2. **Install dependencies:**
    ```bash
    npm install
    ```

3. **Start a local Ethereum node using Hardhat:**
    ```bash
    npx hardhat node
    ```

4. **Deploy the smart contracts:**
    ```bash
   npx hardhat run ignition/scripts/deploy.js --network localhost
    ```

## Data Loader for Spring Boot Application

To set up a default admin user (`admin@gmail.com` with password `welly`)
                                (`nurse@gmail.com` with password `welly`)
                                (`donor@gmail.com` with password `welly`)
                                (`doctor@gmail.com` with password `welly`)
                                , there is a data loader class to the Spring Boot application.


3. **Run the Spring Boot application. The data loader will automatically create the admin user if it doesn't already exist.**

## Conclusion

This README provides the necessary steps to set up and run the full stack application, including the Spring Boot backend, React frontend, and Ethereum blockchain using Hardhat. Additionally, it outlines how to initialize a default admin user in the Spring Boot application.



