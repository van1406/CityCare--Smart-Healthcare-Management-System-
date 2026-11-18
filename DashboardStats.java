package com.citycare.model;

public class DashboardStats {
    private int totalComplaints;
    private int pendingComplaints;     // Submitted + Under Review
    private int assignedComplaints;    // Assigned
    private int inProgressComplaints;  // In Progress
    private int resolvedComplaints;    // Resolved
    private int rejectedComplaints;    // Rejected
    private int totalCitizens;
    private int totalOfficers;
    private int totalDepartments;

    public DashboardStats() {
    }

    public int getTotalComplaints() {
        return totalComplaints;
    }

    public void setTotalComplaints(int totalComplaints) {
        this.totalComplaints = totalComplaints;
    }

    public int getPendingComplaints() {
        return pendingComplaints;
    }

    public void setPendingComplaints(int pendingComplaints) {
        this.pendingComplaints = pendingComplaints;
    }

    public int getAssignedComplaints() {
        return assignedComplaints;
    }

    public void setAssignedComplaints(int assignedComplaints) {
        this.assignedComplaints = assignedComplaints;
    }

    public int getInProgressComplaints() {
        return inProgressComplaints;
    }

    public void setInProgressComplaints(int inProgressComplaints) {
        this.inProgressComplaints = inProgressComplaints;
    }

    public int getResolvedComplaints() {
        return resolvedComplaints;
    }

    public void setResolvedComplaints(int resolvedComplaints) {
        this.resolvedComplaints = resolvedComplaints;
    }

    public int getRejectedComplaints() {
        return rejectedComplaints;
    }

    public void setRejectedComplaints(int rejectedComplaints) {
        this.rejectedComplaints = rejectedComplaints;
    }

    public int getTotalCitizens() {
        return totalCitizens;
    }

    public void setTotalCitizens(int totalCitizens) {
        this.totalCitizens = totalCitizens;
    }

    public int getTotalOfficers() {
        return totalOfficers;
    }

    public void setTotalOfficers(int totalOfficers) {
        this.totalOfficers = totalOfficers;
    }

    public int getTotalDepartments() {
        return totalDepartments;
    }

    public void setTotalDepartments(int totalDepartments) {
        this.totalDepartments = totalDepartments;
    }
}

