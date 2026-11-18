package com.citycare.controller;

import com.citycare.dao.ComplaintDAO;
import com.citycare.dao.DepartmentDAO;
import com.citycare.model.Complaint;
import com.citycare.model.Department;
import com.citycare.model.User;
import com.citycare.util.TrackingIdGenerator;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "SubmitComplaintServlet", urlPatterns = {"/citizen/submit-complaint"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 10,       // 10 MB
        maxRequestSize = 1024 * 1024 * 15     // 15 MB
)
public class SubmitComplaintServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        departmentDAO = new DepartmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Department> departments = departmentDAO.getAllDepartments();
        req.setAttribute("departments", departments);
        req.getRequestDispatcher("/citizen/submit-complaint.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        String title = req.getParameter("title");
        String category = req.getParameter("category");
        String description = req.getParameter("description");
        String location = req.getParameter("location");
        String priority = req.getParameter("priority");
        String deptParam = req.getParameter("departmentId");

        // Retain attributes in case of error
        req.setAttribute("title", title);
        req.setAttribute("category", category);
        req.setAttribute("description", description);
        req.setAttribute("location", location);
        req.setAttribute("priority", priority);
        req.setAttribute("selectedDept", deptParam);
        req.setAttribute("departments", departmentDAO.getAllDepartments());

        // Server-side validation
        if (title == null || title.trim().isEmpty() ||
            category == null || category.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            location == null || location.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Title, category, description, and location are mandatory.");
            req.getRequestDispatcher("/citizen/submit-complaint.jsp").forward(req, resp);
            return;
        }

        // Automatic Department resolution if not chosen manually
        Integer departmentId = null;
        if (deptParam != null && !deptParam.trim().isEmpty()) {
            try {
                departmentId = Integer.parseInt(deptParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        if (departmentId == null || departmentId <= 0) {
            departmentId = resolveDepartmentByCategory(category);
        }

        // Handle File Upload
        String imagePath = null;
        Part filePart = null;
        try {
            filePart = req.getPart("image");
        } catch (Exception ignored) {}

        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String lowerFileName = submittedFileName.toLowerCase();

            if (!lowerFileName.endsWith(".jpg") && !lowerFileName.endsWith(".jpeg") &&
                !lowerFileName.endsWith(".png") && !lowerFileName.endsWith(".webp") &&
                !lowerFileName.endsWith(".gif")) {
                req.setAttribute("errorMessage", "Invalid image format. Allowed formats: JPG, JPEG, PNG, WEBP, GIF.");
                req.getRequestDispatcher("/citizen/submit-complaint.jsp").forward(req, resp);
                return;
            }

            // Save directory
            String uploadDirPath = req.getServletContext().getRealPath("/uploads");
            if (uploadDirPath == null) {
                uploadDirPath = System.getProperty("java.io.tmpdir") + File.separator + "citycare_uploads";
            }
            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String ext = "";
            int dotIdx = submittedFileName.lastIndexOf('.');
            if (dotIdx >= 0) {
                ext = submittedFileName.substring(dotIdx);
            }
            String uniqueFileName = UUID.randomUUID().toString() + ext;
            File targetFile = new File(uploadDir, uniqueFileName);

            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                imagePath = uniqueFileName;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        Complaint complaint = new Complaint();
        complaint.setTrackingId(TrackingIdGenerator.generateTrackingId());
        complaint.setCitizenId(user.getUserId());
        complaint.setTitle(title.trim());
        complaint.setCategory(category.trim());
        complaint.setDescription(description.trim());
        complaint.setLocation(location.trim());
        complaint.setImagePath(imagePath);
        complaint.setPriority(priority != null && !priority.trim().isEmpty() ? priority.trim() : "Medium");
        complaint.setDepartmentId(departmentId);

        boolean success = complaintDAO.createComplaint(complaint);
        if (success) {
            session.setAttribute("successMessage", "Complaint submitted successfully! Your tracking ID is " + complaint.getTrackingId());
            resp.sendRedirect(req.getContextPath() + "/citizen/complaint-details?id=" + complaint.getComplaintId());
        } else {
            req.setAttribute("errorMessage", "Failed to submit complaint due to a server error. Please try again.");
            req.getRequestDispatcher("/citizen/submit-complaint.jsp").forward(req, resp);
        }
    }

    private Integer resolveDepartmentByCategory(String category) {
        String cat = category.toLowerCase();
        if (cat.contains("road") || cat.contains("pothole") || cat.contains("bridge") || cat.contains("traffic")) {
            return 1; // Roads and Infrastructure
        } else if (cat.contains("garbage") || cat.contains("sanitation") || cat.contains("waste") || cat.contains("dustbin")) {
            return 2; // Sanitation
        } else if (cat.contains("water") || cat.contains("pipe") || cat.contains("leakage")) {
            return 3; // Water Supply
        } else if (cat.contains("electric") || cat.contains("light") || cat.contains("power") || cat.contains("pole")) {
            return 4; // Electricity
        } else if (cat.contains("drain") || cat.contains("sew") || cat.contains("flood")) {
            return 5; // Drainage and Sewage
        }
        return null;
    }
}

