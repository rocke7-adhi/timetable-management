-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'staff', 'student') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Staff table
CREATE TABLE staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Classes table
CREATE TABLE classes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    semester INT,
    section VARCHAR(10)
) ENGINE=InnoDB;

-- Students table
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    name VARCHAR(100) NOT NULL,
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    class_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id)
) ENGINE=InnoDB;

-- Staff assignments table
CREATE TABLE assignments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT,
    class_id INT,
    subject VARCHAR(50) NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Timetable table
CREATE TABLE timetable (
    id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT,
    staff_id INT,
    subject VARCHAR(50) NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Leave requests table
CREATE TABLE leave_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES staff(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Insert sample data
INSERT INTO users (username, password, role) VALUES ('admin', 'admin123', 'admin');

-- Sample departments and classes
INSERT INTO classes (name, department, semester, section) VALUES 
('CSE-A', 'Computer Science', 1, 'A'),
('CSE-B', 'Computer Science', 1, 'B'),
('ECE-A', 'Electronics', 1, 'A'),
('IT-A', 'Information Technology', 1, 'A'),
('MECH-A', 'Mechanical', 1, 'A');

-- Sample staff users
INSERT INTO users (username, password, role) VALUES
('staff1', 'staff123', 'staff'),
('staff2', 'staff123', 'staff'),
('staff3', 'staff123', 'staff'),
('staff4', 'staff123', 'staff');

-- Sample staff details
INSERT INTO staff (user_id, name, department) VALUES
((SELECT id FROM users WHERE username = 'staff1'), 'John Doe', 'Computer Science'),
((SELECT id FROM users WHERE username = 'staff2'), 'Jane Smith', 'Electronics'),
((SELECT id FROM users WHERE username = 'staff3'), 'Robert Johnson', 'Information Technology'),
((SELECT id FROM users WHERE username = 'staff4'), 'Mary Williams', 'Computer Science');

-- Sample student users
INSERT INTO users (username, password, role) VALUES
('student1', 'student123', 'student'),
('student2', 'student123', 'student'),
('student3', 'student123', 'student');

-- Sample student details
INSERT INTO students (user_id, name, roll_number, class_id) VALUES
((SELECT id FROM users WHERE username = 'student1'), 'Alice Johnson', 'CSE001', (SELECT id FROM classes WHERE name = 'CSE-A')),
((SELECT id FROM users WHERE username = 'student2'), 'Bob Wilson', 'CSE002', (SELECT id FROM classes WHERE name = 'CSE-A')),
((SELECT id FROM users WHERE username = 'student3'), 'Charlie Brown', 'ECE001', (SELECT id FROM classes WHERE name = 'ECE-A'));

-- Sample assignments
INSERT INTO assignments (staff_id, class_id, subject) VALUES
((SELECT id FROM staff WHERE name = 'John Doe'), (SELECT id FROM classes WHERE name = 'CSE-A'), 'Programming'),
((SELECT id FROM staff WHERE name = 'Jane Smith'), (SELECT id FROM classes WHERE name = 'CSE-A'), 'Digital Electronics'),
((SELECT id FROM staff WHERE name = 'Robert Johnson'), (SELECT id FROM classes WHERE name = 'CSE-A'), 'Database Management'),
((SELECT id FROM staff WHERE name = 'Mary Williams'), (SELECT id FROM classes WHERE name = 'CSE-A'), 'Web Development');

-- Sample timetable entries for CSE-A
INSERT INTO timetable (class_id, staff_id, subject, day_of_week, start_time, end_time) VALUES
-- Monday
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'John Doe'), 'Programming', 'Monday', '09:00:00', '10:00:00'),
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'Jane Smith'), 'Digital Electronics', 'Monday', '10:00:00', '11:00:00'),
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'Robert Johnson'), 'Database Management', 'Monday', '11:15:00', '12:15:00'),
-- Tuesday
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'Mary Williams'), 'Web Development', 'Tuesday', '09:00:00', '10:00:00'),
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'John Doe'), 'Programming Lab', 'Tuesday', '10:00:00', '12:00:00'),
-- Wednesday
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'Jane Smith'), 'Digital Electronics', 'Wednesday', '09:00:00', '10:00:00'),
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'Robert Johnson'), 'Database Management', 'Wednesday', '10:00:00', '11:00:00'),
-- Thursday
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'Mary Williams'), 'Web Development', 'Thursday', '09:00:00', '10:00:00'),
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'Jane Smith'), 'Digital Lab', 'Thursday', '10:00:00', '12:00:00'),
-- Friday
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'John Doe'), 'Programming', 'Friday', '09:00:00', '10:00:00'),
((SELECT id FROM classes WHERE name = 'CSE-A'), (SELECT id FROM staff WHERE name = 'Robert Johnson'), 'DBMS Lab', 'Friday', '10:00:00', '12:00:00');

-- Sample leave requests
INSERT INTO leave_requests (staff_id, start_date, end_date, reason, status) VALUES
((SELECT id FROM staff WHERE name = 'John Doe'), '2024-03-20', '2024-03-22', 'Personal work', 'pending'),
((SELECT id FROM staff WHERE name = 'Jane Smith'), '2024-03-25', '2024-03-26', 'Medical appointment', 'approved'),
((SELECT id FROM staff WHERE name = 'Robert Johnson'), '2024-03-15', '2024-03-15', 'Family function', 'rejected'); 