import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/student_portal",
                "root",
                "pranav@123"
            );

            PreparedStatement ps = con.prepareStatement(
                "SELECT student_id, name, department, study_year FROM students WHERE email=? AND password=?"
            );
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession(true);
                session.setAttribute("student_id", rs.getInt("student_id"));
                session.setAttribute("email", email);
                session.setAttribute("studentName", rs.getString("name"));
                session.setAttribute("department", rs.getString("department"));
                session.setAttribute("studyYear", rs.getString("study_year"));

                response.sendRedirect("profile.jsp");
            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        }
    }
}
