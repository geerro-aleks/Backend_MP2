-- Create Database
CREATE DATABASE WebAppDB;

-- Use the Database
USE WebAppDB;

-- Create Account Table
CREATE TABLE account (
    user_name VARCHAR(30) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    user_role ENUM('user', 'admin', 'super_admin') NOT NULL
);

-- Create Posts Table (Each user can have up to 5 posts)
CREATE TABLE posts (
    user_name VARCHAR(30) PRIMARY KEY,
    post1 VARCHAR(200),
    post2 VARCHAR(200),
    post3 VARCHAR(200),
    post4 VARCHAR(200),
    post5 VARCHAR(200),
    FOREIGN KEY (user_name) REFERENCES account(user_name) ON DELETE CASCADE
);

-- Create Follows Table (Each user can follow up to 3 users)
CREATE TABLE follows (
    user_name VARCHAR(30) PRIMARY KEY,
    follow1 VARCHAR(30),
    follow2 VARCHAR(30),
    follow3 VARCHAR(30),
    FOREIGN KEY (user_name) REFERENCES account(user_name),
    FOREIGN KEY (follow1) REFERENCES account(user_name),
    FOREIGN KEY (follow2) REFERENCES account(user_name),
    FOREIGN KEY (follow3) REFERENCES account(user_name)
);

INSERT INTO account (user_name, password, user_role) VALUES 
("johanna", "123", "user"),
("julia", "999", "user"),
("alex", "888", "user"),
("louisse", "777", "user"),
("aleksei", "555", "user"),
("jc", "456", "admin"),
("jyro", "789", "super_admin");

