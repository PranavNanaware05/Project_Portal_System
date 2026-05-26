import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AddProjectServlet")
public class AddProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔐 Session validation - Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 👤 Get logged-in student ID from session
        int studentId = (Integer) session.getAttribute("student_id");

        // 📥 Get form data from addProject.jsp
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String skills = request.getParameter("skills");

        // ✅ Validate required fields
        if (title == null || title.trim().isEmpty()) {
            response.sendRedirect("addProject.jsp?error=Project Title is required");
            return;
        }
        if (description == null || description.trim().isEmpty()) {
            response.sendRedirect("addProject.jsp?error=Project Description is required");
            return;
        }
        if (type == null || type.trim().isEmpty()) {
            response.sendRedirect("addProject.jsp?error=Project Type is required");
            return;
        }
        if (status == null || status.trim().isEmpty()) {
            response.sendRedirect("addProject.jsp?error=Project Status is required");
            return;
        }

        // Set default for skills if empty
        if (skills == null || skills.trim().isEmpty()) {
            skills = "";
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // 1. Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Connect to database
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/student_portal",
                "root",
                "pranav@123"
            );

            // 3. SQL Query to insert project
            String sql = "INSERT INTO projects (title, description, type, status, skills, created_by) VALUES (?, ?, ?, ?, ?, ?)";
            
            ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, type);
            ps.setString(4, status);
            ps.setString(5, skills);
            ps.setInt(6, studentId);

            // 4. Execute the query
            int result = ps.executeUpdate();

            // 5. Check if insertion was successful
            if (result > 0) {
                // Success - redirect to view projects page with success message
                response.sendRedirect("viewProject.jsp?success=Project added successfully!");
            } else {
                // Failed - redirect back with error message
                response.sendRedirect("addProject.jsp?error=Failed to add project. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addProject.jsp?error=Database Error: " + e.getMessage());
        } finally {
            // Close connections
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}