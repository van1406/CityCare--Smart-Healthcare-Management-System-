package com.citycare.model;

import java.sql.Timestamp;

public class Department {
    private int departmentId;
    private String departmentName;
    private String description;
    private String contactEmail;
    private Timestamp createdAt;

    public Department() {
    }

    public Department(int departmentId, String departmentName, String description, String contactEmail) {
        this.departmentId = departmentId;
        this.departmentName = departmentName;
        this.description = description;
        this.contactEmail = contactEmail;
    }

    public int getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

