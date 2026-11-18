package com.citycare.dao;

import com.citycare.model.Officer;
import com.citycare.model.User;
import com.citycare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OfficerDAO {

    public List<Officer> getAllOfficers() {
        List<Officer> list = new ArrayList<>();
        String sql = "SELECT o.officer_id, o.user_id, o.department_id, o.designation, o.created_at, " +
                     "u.full_name, u.email, u.phone, u.status, d.department_name " +
                     "FROM officers o " +
                     "JOIN users u ON o.user_id = u.user_id " +
                     "JOIN departments d ON o.department_id = d.department_id " +
                     "ORDER BY d.department_name, u.full_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToOfficer(rs));
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("OfficerDAO database operation", e);
        }
        return list;
    }

    public List<Officer> getOfficersByDepartment(int departmentId) {
        List<Officer> list = new ArrayList<>();
        String sql = "SELECT o.officer_id, o.user_id, o.department_id, o.designation, o.created_at, " +
                     "u.full_name, u.email, u.phone, u.status, d.department_name " +
                     "FROM officers o " +
                     "JOIN users u ON o.user_id = u.user_id " +
                     "JOIN departments d ON o.department_id = d.department_id " +
                     "WHERE o.department_id = ? AND u.status = 'ACTIVE' " +
                     "ORDER BY u.full_name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToOfficer(rs));
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("OfficerDAO database operation", e);
        }
        return list;
    }

    public Officer getOfficerByUserId(int userId) {
        String sql = "SELECT o.officer_id, o.user_id, o.department_id, o.designation, o.created_at, " +
                     "u.full_name, u.email, u.phone, u.status, d.department_name " +
                     "FROM officers o " +
                     "JOIN users u ON o.user_id = u.user_id " +
                     "JOIN departments d ON o.department_id = d.department_id " +
                     "WHERE o.user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToOfficer(rs);
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("OfficerDAO database operation", e);
        }
        return null;
    }

    public Officer getOfficerById(int officerId) {
        String sql = "SELECT o.officer_id, o.user_id, o.department_id, o.designation, o.created_at, " +
                     "u.full_name, u.email, u.phone, u.status, d.department_name " +
                     "FROM officers o " +
                     "JOIN users u ON o.user_id = u.user_id " +
                     "JOIN departments d ON o.department_id = d.department_id " +
                     "WHERE o.officer_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, officerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToOfficer(rs);
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("OfficerDAO database operation", e);
        }
        return null;
    }

    public boolean addOfficer(User user, int departmentId, String designation) {
        String insertUserSql = "INSERT INTO users (full_name, email, phone, address, password_hash, role, status) VALUES (?, ?, ?, ?, ?, 'OFFICER', 'ACTIVE')";
        String insertOfficerSql = "INSERT INTO officers (user_id, department_id, designation) VALUES (?, ?, ?)";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            int userId;
            try (PreparedStatement psUser = con.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, user.getFullName());
                psUser.setString(2, user.getEmail().trim().toLowerCase());
                psUser.setString(3, user.getPhone());
                psUser.setString(4, user.getAddress());
                psUser.setString(5, user.getPasswordHash());
                psUser.executeUpdate();

                try (ResultSet rs = psUser.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1);
                    } else {
                        con.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement psOfficer = con.prepareStatement(insertOfficerSql)) {
                psOfficer.setInt(1, userId);
                psOfficer.setInt(2, departmentId);
                psOfficer.setString(3, (designation == null || designation.trim().isEmpty()) ? "Municipal Officer" : designation);
                psOfficer.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    DBConnection.logDatabaseError("OfficerDAO transaction rollback", ex);
                }
            }
            DBConnection.logDatabaseError("OfficerDAO database operation", e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    DBConnection.logDatabaseError("OfficerDAO transaction rollback", ex);
                }
            }
        }
        return false;
    }

    public boolean updateOfficer(int officerId, int departmentId, String designation) {
        String sql = "UPDATE officers SET department_id = ?, designation = ? WHERE officer_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, departmentId);
            ps.setString(2, designation);
            ps.setInt(3, officerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            DBConnection.logDatabaseError("OfficerDAO database operation", e);
        }
        return false;
    }

    public int countOfficers() {
        String sql = "SELECT COUNT(*) FROM officers";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("OfficerDAO database operation", e);
        }
        return 0;
    }

    private Officer mapRowToOfficer(ResultSet rs) throws SQLException {
        Officer o = new Officer();
        o.setOfficerId(rs.getInt("officer_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setDepartmentId(rs.getInt("department_id"));
        o.setDesignation(rs.getString("designation"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setFullName(rs.getString("full_name"));
        o.setEmail(rs.getString("email"));
        o.setPhone(rs.getString("phone"));
        o.setStatus(rs.getString("status"));
        o.setDepartmentName(rs.getString("department_name"));
        return o;
    }
}

