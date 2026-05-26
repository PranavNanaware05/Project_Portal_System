<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate (destroy) the current session
    session.invalidate();
    
    // Redirect to login page with logout success message
    response.sendRedirect("login.jsp?logout=success");
%>