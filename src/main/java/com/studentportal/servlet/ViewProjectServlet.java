package com.studentportal.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;



@WebServlet("/ViewProjectServlet")
public class ViewProjectServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Project> projectList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/student_portal",
                "root",
                "pranav@123"
            );

            PreparedStatement ps =
                con.prepareStatement("SELECT * FROM projects ORDER BY id DESC");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Project p = new Project();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setDescription(rs.getString("description"));
                p.setType(rs.getString("type"));
                p.setStatus(rs.getString("status"));
                p.setSkills(rs.getString("skills"));
                projectList.add(p);
            }

            con.close();

            request.setAttribute("projects", projectList);
            request.getRequestDispatcher("viewProject.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
