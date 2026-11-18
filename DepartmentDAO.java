package com.citycare.dao;

import com.citycare.model.Department;
import com.citycare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {

    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM departments ORDER BY department_name ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Department d = new Department();
                d.setDepartmentId(rs.getInt("department_id"));
                d.setDepartmentName(rs.getString("department_name"));
                d.setDescription(rs.getString("description"));
                d.setContactEmail(rs.getString("contact_email"));
                d.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(d);
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("DepartmentDAO database operation", e);
        }
        return list;
    }

    public Department getDepartmentById(int departmentId) {
        String sql = "SELECT * FROM departments WHERE department_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Department d = new Department();
                    d.setDepartmentId(rs.getInt("department_id"));
                    d.setDepartmentName(rs.getString("department_name"));
                    d.setDescription(rs.getString("description"));
                    d.setContactEmail(rs.getString("contact_email"));
                    d.setCreatedAt(rs.getTimestamp("created_at"));
                    return d;
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("DepartmentDAO database operation", e);
        }
        return null;
    }

    public int countDepartments() {
        String sql = "SELECT COUNT(*) FROM departments";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("DepartmentDAO database operation", e);
        }
        return 0;
    }
}

