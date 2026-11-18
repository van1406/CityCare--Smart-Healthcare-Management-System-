package com.citycare.dao;

import com.citycare.model.Complaint;
import com.citycare.model.ComplaintHistory;
import com.citycare.model.DashboardStats;
import com.citycare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    public boolean createComplaint(Complaint c) {
        String insertSql = "INSERT INTO complaints (tracking_id, citizen_id, title, category, description, location, image_path, status, priority, department_id, assigned_officer_id) " +
                           "VALUES (?, ?, ?, ?, ?, ?, ?, 'Submitted', ?, ?, ?)";
        String historySql = "INSERT INTO complaint_history (complaint_id, updated_by, old_status, new_status, remarks) VALUES (?, ?, NULL, 'Submitted', 'Complaint submitted by citizen.')";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            int complaintId;
            try (PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, c.getTrackingId());
                ps.setInt(2, c.getCitizenId());
                ps.setString(3, c.getTitle());
                ps.setString(4, c.getCategory());
                ps.setString(5, c.getDescription());
                ps.setString(6, c.getLocation());
                ps.setString(7, c.getImagePath());
                ps.setString(8, c.getPriority() != null ? c.getPriority() : "Medium");

                if (c.getDepartmentId() != null && c.getDepartmentId() > 0) {
                    ps.setInt(9, c.getDepartmentId());
                } else {
                    ps.setNull(9, Types.INTEGER);
                }

                if (c.getAssignedOfficerId() != null && c.getAssignedOfficerId() > 0) {
                    ps.setInt(10, c.getAssignedOfficerId());
                } else {
                    ps.setNull(10, Types.INTEGER);
                }

                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        complaintId = rs.getInt(1);
                        c.setComplaintId(complaintId);
                    } else {
                        con.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement psHist = con.prepareStatement(historySql)) {
                psHist.setInt(1, complaintId);
                psHist.setInt(2, c.getCitizenId());
                psHist.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    DBConnection.logDatabaseError("ComplaintDAO transaction rollback", ex);
                }
            }
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    DBConnection.logDatabaseError("ComplaintDAO transaction rollback", ex);
                }
            }
        }
        return false;
    }

    public Complaint getComplaintById(int complaintId) {
        String sql = baseComplaintQuery() + " WHERE c.complaint_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToComplaint(rs);
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        }
        return null;
    }

    public Complaint getComplaintByTrackingId(String trackingId) {
        String sql = baseComplaintQuery() + " WHERE LOWER(c.tracking_id) = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, trackingId.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToComplaint(rs);
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        }
        return null;
    }

    public List<Complaint> getComplaintsByCitizen(int citizenId) {
        List<Complaint> list = new ArrayList<>();
        String sql = baseComplaintQuery() + " WHERE c.citizen_id = ? ORDER BY c.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, citizenId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToComplaint(rs));
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        }
        return list;
    }

    public List<Complaint> getComplaintsByOfficer(int officerUserId, String category, String status, String keyword) {
        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(baseComplaintQuery());
        sql.append(" WHERE c.assigned_officer_id = ?");

        List<Object> params = new ArrayList<>();
        params.add(officerUserId);

        appendFilters(sql, params, category, status, null, keyword);
        sql.append(" ORDER BY c.created_at DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToComplaint(rs));
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        }
        return list;
    }

    public List<Complaint> getAllComplaints(String category, String status, Integer departmentId, String keyword) {
        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(baseComplaintQuery());
        sql.append(" WHERE 1=1");

        List<Object> params = new ArrayList<>();
        appendFilters(sql, params, category, status, departmentId, keyword);
        sql.append(" ORDER BY c.created_at DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToComplaint(rs));
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        }
        return list;
    }

    public boolean updateStatus(int complaintId, String newStatus, int updatedByUserId, String remarks) {
        String fetchOldStatusSql = "SELECT status FROM complaints WHERE complaint_id = ?";
        String updateStatusSql = "UPDATE complaints SET status = ? WHERE complaint_id = ?";
        String historySql = "INSERT INTO complaint_history (complaint_id, updated_by, old_status, new_status, remarks) VALUES (?, ?, ?, ?, ?)";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String oldStatus = null;
            try (PreparedStatement psOld = con.prepareStatement(fetchOldStatusSql)) {
                psOld.setInt(1, complaintId);
                try (ResultSet rs = psOld.executeQuery()) {
                    if (rs.next()) {
                        oldStatus = rs.getString("status");
                    } else {
                        con.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement psUp = con.prepareStatement(updateStatusSql)) {
                psUp.setString(1, newStatus);
                psUp.setInt(2, complaintId);
                psUp.executeUpdate();
            }

            try (PreparedStatement psHist = con.prepareStatement(historySql)) {
                psHist.setInt(1, complaintId);
                psHist.setInt(2, updatedByUserId);
                psHist.setString(3, oldStatus);
                psHist.setString(4, newStatus);
                psHist.setString(5, (remarks == null || remarks.trim().isEmpty()) ? "Status updated to " + newStatus : remarks.trim());
                psHist.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    DBConnection.logDatabaseError("ComplaintDAO transaction rollback", ex);
                }
            }
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    DBConnection.logDatabaseError("ComplaintDAO transaction rollback", ex);
                }
            }
        }
        return false;
    }

    public boolean assignDepartmentAndOfficer(int complaintId, Integer departmentId, Integer officerUserId, int updatedByUserId, String remarks) {
        String fetchOldStatusSql = "SELECT status FROM complaints WHERE complaint_id = ?";
        String updateSql = "UPDATE complaints SET department_id = ?, assigned_officer_id = ?, status = 'Assigned' WHERE complaint_id = ?";
        String historySql = "INSERT INTO complaint_history (complaint_id, updated_by, old_status, new_status, remarks) VALUES (?, ?, ?, 'Assigned', ?)";

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String oldStatus = "Submitted";
            try (PreparedStatement psOld = con.prepareStatement(fetchOldStatusSql)) {
                psOld.setInt(1, complaintId);
                try (ResultSet rs = psOld.executeQuery()) {
                    if (rs.next()) {
                        oldStatus = rs.getString("status");
                    }
                }
            }

            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                if (departmentId != null && departmentId > 0) {
                    ps.setInt(1, departmentId);
                } else {
                    ps.setNull(1, Types.INTEGER);
                }

                if (officerUserId != null && officerUserId > 0) {
                    ps.setInt(2, officerUserId);
                } else {
                    ps.setNull(2, Types.INTEGER);
                }

                ps.setInt(3, complaintId);
                ps.executeUpdate();
            }

            try (PreparedStatement psHist = con.prepareStatement(historySql)) {
                psHist.setInt(1, complaintId);
                psHist.setInt(2, updatedByUserId);
                psHist.setString(3, oldStatus);
                psHist.setString(4, (remarks == null || remarks.trim().isEmpty()) ? "Complaint assigned to department/officer." : remarks.trim());
                psHist.executeUpdate();
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    DBConnection.logDatabaseError("ComplaintDAO transaction rollback", ex);
                }
            }
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    DBConnection.logDatabaseError("ComplaintDAO transaction rollback", ex);
                }
            }
        }
        return false;
    }

    public List<ComplaintHistory> getComplaintHistory(int complaintId) {
        List<ComplaintHistory> list = new ArrayList<>();
        String sql = "SELECT h.history_id, h.complaint_id, h.updated_by, h.old_status, h.new_status, h.remarks, h.updated_at, " +
                     "u.full_name AS updater_name, u.role AS updater_role " +
                     "FROM complaint_history h " +
                     "JOIN users u ON h.updated_by = u.user_id " +
                     "WHERE h.complaint_id = ? " +
                     "ORDER BY h.updated_at ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ComplaintHistory h = new ComplaintHistory();
                    h.setHistoryId(rs.getInt("history_id"));
                    h.setComplaintId(rs.getInt("complaint_id"));
                    h.setUpdatedBy(rs.getInt("updated_by"));
                    h.setUpdaterName(rs.getString("updater_name"));
                    h.setUpdaterRole(rs.getString("updater_role"));
                    h.setOldStatus(rs.getString("old_status"));
                    h.setNewStatus(rs.getString("new_status"));
                    h.setRemarks(rs.getString("remarks"));
                    h.setUpdatedAt(rs.getTimestamp("updated_at"));
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        }
        return list;
    }

    public DashboardStats getCitizenDashboardStats(int citizenId) {
        DashboardStats stats = new DashboardStats();
        String sql = "SELECT " +
                     "COUNT(*) AS total, " +
                     "SUM(CASE WHEN status IN ('Submitted', 'Under Review') THEN 1 ELSE 0 END) AS pending, " +
                     "SUM(CASE WHEN status = 'Assigned' THEN 1 ELSE 0 END) AS assigned, " +
                     "SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END) AS in_progress, " +
                     "SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) AS resolved, " +
                     "SUM(CASE WHEN status = 'Rejected' THEN 1 ELSE 0 END) AS rejected " +
                     "FROM complaints WHERE citizen_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, citizenId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.setTotalComplaints(rs.getInt("total"));
                    stats.setPendingComplaints(rs.getInt("pending"));
                    stats.setAssignedComplaints(rs.getInt("assigned"));
                    stats.setInProgressComplaints(rs.getInt("in_progress"));
                    stats.setResolvedComplaints(rs.getInt("resolved"));
                    stats.setRejectedComplaints(rs.getInt("rejected"));
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        }
        return stats;
    }

    public DashboardStats getOfficerDashboardStats(int officerUserId) {
        DashboardStats stats = new DashboardStats();
        String sql = "SELECT " +
                     "COUNT(*) AS total, " +
                     "SUM(CASE WHEN status IN ('Submitted', 'Under Review') THEN 1 ELSE 0 END) AS pending, " +
                     "SUM(CASE WHEN status = 'Assigned' THEN 1 ELSE 0 END) AS assigned, " +
                     "SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END) AS in_progress, " +
                     "SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) AS resolved, " +
                     "SUM(CASE WHEN status = 'Rejected' THEN 1 ELSE 0 END) AS rejected " +
                     "FROM complaints WHERE assigned_officer_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, officerUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.setTotalComplaints(rs.getInt("total"));
                    stats.setPendingComplaints(rs.getInt("pending"));
                    stats.setAssignedComplaints(rs.getInt("assigned"));
                    stats.setInProgressComplaints(rs.getInt("in_progress"));
                    stats.setResolvedComplaints(rs.getInt("resolved"));
                    stats.setRejectedComplaints(rs.getInt("rejected"));
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        }
        return stats;
    }

    public DashboardStats getAdminDashboardStats() {
        DashboardStats stats = new DashboardStats();
        String complaintStatsSql = "SELECT " +
                                   "COUNT(*) AS total, " +
                                   "SUM(CASE WHEN status IN ('Submitted', 'Under Review') THEN 1 ELSE 0 END) AS pending, " +
                                   "SUM(CASE WHEN status = 'Assigned' THEN 1 ELSE 0 END) AS assigned, " +
                                   "SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END) AS in_progress, " +
                                   "SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END) AS resolved, " +
                                   "SUM(CASE WHEN status = 'Rejected' THEN 1 ELSE 0 END) AS rejected " +
                                   "FROM complaints";
        String countsSql = "SELECT " +
                           "(SELECT COUNT(*) FROM users WHERE role = 'CITIZEN') AS citizens, " +
                           "(SELECT COUNT(*) FROM officers) AS officers, " +
                           "(SELECT COUNT(*) FROM departments) AS departments";

        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(complaintStatsSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.setTotalComplaints(rs.getInt("total"));
                    stats.setPendingComplaints(rs.getInt("pending"));
                    stats.setAssignedComplaints(rs.getInt("assigned"));
                    stats.setInProgressComplaints(rs.getInt("in_progress"));
                    stats.setResolvedComplaints(rs.getInt("resolved"));
                    stats.setRejectedComplaints(rs.getInt("rejected"));
                }
            }
            try (PreparedStatement ps = con.prepareStatement(countsSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.setTotalCitizens(rs.getInt("citizens"));
                    stats.setTotalOfficers(rs.getInt("officers"));
                    stats.setTotalDepartments(rs.getInt("departments"));
                }
            }
        } catch (SQLException e) {
            DBConnection.logDatabaseError("ComplaintDAO database operation", e);
        }
        return stats;
    }

    private String baseComplaintQuery() {
        return "SELECT c.*, " +
               "cit.full_name AS citizen_name, cit.email AS citizen_email, cit.phone AS citizen_phone, " +
               "d.department_name, " +
               "off.full_name AS assigned_officer_name " +
               "FROM complaints c " +
               "JOIN users cit ON c.citizen_id = cit.user_id " +
               "LEFT JOIN departments d ON c.department_id = d.department_id " +
               "LEFT JOIN users off ON c.assigned_officer_id = off.user_id";
    }

    private void appendFilters(StringBuilder sql, List<Object> params, String category, String status, Integer departmentId, String keyword) {
        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("ALL")) {
            sql.append(" AND c.category = ?");
            params.add(category.trim());
        }
        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("ALL")) {
            sql.append(" AND c.status = ?");
            params.add(status.trim());
        }
        if (departmentId != null && departmentId > 0) {
            sql.append(" AND c.department_id = ?");
            params.add(departmentId);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            String pattern = "%" + keyword.trim().toLowerCase() + "%";
            sql.append(" AND (LOWER(c.tracking_id) LIKE ? OR LOWER(c.title) LIKE ? OR LOWER(c.description) LIKE ? OR LOWER(c.location) LIKE ?)");
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }
    }

    private Complaint mapRowToComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setComplaintId(rs.getInt("complaint_id"));
        c.setTrackingId(rs.getString("tracking_id"));
        c.setCitizenId(rs.getInt("citizen_id"));
        c.setTitle(rs.getString("title"));
        c.setCategory(rs.getString("category"));
        c.setDescription(rs.getString("description"));
        c.setLocation(rs.getString("location"));
        c.setImagePath(rs.getString("image_path"));
        c.setStatus(rs.getString("status"));
        c.setPriority(rs.getString("priority"));

        int deptId = rs.getInt("department_id");
        if (!rs.wasNull()) {
            c.setDepartmentId(deptId);
        }

        int officerId = rs.getInt("assigned_officer_id");
        if (!rs.wasNull()) {
            c.setAssignedOfficerId(officerId);
        }

        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));

        c.setCitizenName(rs.getString("citizen_name"));
        c.setCitizenEmail(rs.getString("citizen_email"));
        c.setCitizenPhone(rs.getString("citizen_phone"));
        c.setDepartmentName(rs.getString("department_name"));
        c.setAssignedOfficerName(rs.getString("assigned_officer_name"));
        return c;
    }
}

