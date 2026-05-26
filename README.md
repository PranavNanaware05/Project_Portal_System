# 📚 Student Project Portal System

> *A Complete Project Management Platform for Students*

[![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com/)
[![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)](https://www.oracle.com/java/technologies/jspt.html)
[![Servlet](https://img.shields.io/badge/Servlet-007396?style=for-the-badge&logo=java&logoColor=white)](https://www.oracle.com/java/technologies/java-ee-servlet.html)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/HTML)
[![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/CSS)
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)](https://www.javascript.com/)
[![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)](https://tomcat.apache.org/)
[![Eclipse](https://img.shields.io/badge/Eclipse-2C2255?style=for-the-badge&logo=eclipse&logoColor=white)](https://www.eclipse.org/)

---

<div align="center">

## 🚀 **Welcome to Student Project Portal**

### *Your One-Stop Solution for Academic Project Management*

</div>

---

## 🎯 Project Overview

**Student Project Portal System** is a web-based platform that allows students to submit and manage their academic projects. The system provides an easy-to-use interface for students to submit, track, and manage their projects.

<div align="center">

| Issue | Our Solution |
|:------|:-------------|
| ❌ Manual project submission on paper | ✅ Online project submission |
| ❌ No centralized project tracking | ✅ Real-time project status tracking |
| ❌ Difficulty tracking project status | ✅ Centralized project database |
| ❌ No proper project history | ✅ Complete project history |

</div>

---

## ✨ Features

<div align="center">

### 🟢 **Authentication & Security**
🔐 Secure Login & Registration | 🔄 Password Reset via Email | 👤 Profile Management

### 🔵 **Project Management**
📝 Submit New Projects | 📋 View All Projects | ✏️ Edit Project Details | 🗑️ Delete Projects

### 🟣 **Status Tracking**
⏳ Pending Review | ✅ Approved Projects | ❌ Rejected Projects | 🔄 Resubmit Option

</div>

---

## 🔄 Workflow Diagram

### Student Journey Flowchart

```mermaid
flowchart TB
    subgraph "🟢 1. AUTHENTICATION"
        A[📝 Register New Account]
        B[🔐 Login to Portal]
    end
    
    subgraph "🟡 2. DASHBOARD"
        C[📊 View Dashboard]
        D[👤 View Profile]
    end
    
    subgraph "🔵 3. PROJECT MANAGEMENT"
        E[📤 Submit New Project]
        F[📋 View My Projects]
        G[✏️ Edit Project]
        H[🗑️ Delete Project]
    end
    
    subgraph "🟣 4. STATUS TRACKING"
        I[⏳ Pending Review]
        J[✅ Approved]
        K[❌ Rejected]
        L[🔄 Resubmit]
    end
    
    A --> B --> C
    C --> D
    C --> E
    C --> F
    F --> G
    F --> H
    E --> I
    I --> J
    I --> K
    K --> L
    L --> E
    
    style A fill:#2ecc71,stroke:#27ae60,stroke-width:2px,color:white
    style B fill:#2ecc71,stroke:#27ae60,stroke-width:2px,color:white
    style C fill:#f1c40f,stroke:#f39c12,stroke-width:2px,color:black
    style D fill:#f1c40f,stroke:#f39c12,stroke-width:2px,color:black
    style E fill:#3498db,stroke:#2980b9,stroke-width:2px,color:white
    style F fill:#3498db,stroke:#2980b9,stroke-width:2px,color:white
    style G fill:#3498db,stroke:#2980b9,stroke-width:2px,color:white
    style H fill:#e74c3c,stroke:#c0392b,stroke-width:2px,color:white
    style I fill:#f39c12,stroke:#e67e22,stroke-width:2px,color:black
    style J fill:#2ecc71,stroke:#27ae60,stroke-width:2px,color:white
    style K fill:#e74c3c,stroke:#c0392b,stroke-width:2px,color:white
    style L fill:#9b59b6,stroke:#8e44ad,stroke-width:2px,color:white
