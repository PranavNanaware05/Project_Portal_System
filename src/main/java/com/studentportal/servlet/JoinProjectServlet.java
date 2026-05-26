package com.studentportal.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/joinProject")
public class JoinProjectServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("student_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (int) session.getAttribute("student_id");
        String projectIdStr = request.getParameter("project_id");

        if (projectIdStr == null || projectIdStr.isEmpty()) {
            response.sendRedirect("viewProject.jsp");
            return;
        }

        int projectId = Integer.parseInt(projectIdStr);

        String skills = request.getParameter("skills");
        String experience = request.getParameter("experience");
        String message = request.getParameter("message");
        String availability = request.getParameter("availability");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/student_portal",
                "root",
                "pranav@123"
            );

            // ✅ DUPLICATE CHECK
            PreparedStatement check = con.prepareStatement(
                "SELECT application_id FROM project_applications WHERE project_id=? AND student_id=?"
            );
            check.setInt(1, projectId);
            check.setInt(2, studentId);

            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                response.getWriter().println(
                    "<script>alert('You already applied for this project');location='viewProject.jsp';</script>"
                );
                return;
            }

            // ✅ INSERT APPLICATION
            PreparedStatement insert = con.prepareStatement(
                "INSERT INTO project_applications " +
                "(project_id, student_id, skills, experience, message, availability) " +
                "VALUES (?, ?, ?, ?, ?, ?)"
            );

            insert.setInt(1, projectId);
            insert.setInt(2, studentId);
            insert.setString(3, skills);
            insert.setString(4, experience);
            insert.setString(5, message);
            insert.setString(6, availability);

            insert.executeUpdate();

            response.getWriter().println(
                "<script>alert('Application submitted successfully');location='viewProject.jsp';</script>"
            );

            con.close();

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
