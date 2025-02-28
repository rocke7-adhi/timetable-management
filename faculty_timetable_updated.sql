-- Drop existing tables if they exist
DROP TABLE IF EXISTS substitutions;
DROP TABLE IF EXISTS leave_requests;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS time_slots;
DROP TABLE IF EXISTS users;

-- Create tables in correct order
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

-- Time slots table
CREATE TABLE time_slots (
    id INT PRIMARY KEY AUTO_INCREMENT,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    slot_name VARCHAR(50)
) ENGINE=InnoDB;

-- Classes table
CREATE TABLE classes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    subject VARCHAR(100) NOT NULL,
    teacher_id INT,
    schedule VARCHAR(255),
    department VARCHAR(50),
    semester INT,
    section VARCHAR(10),
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'),
    time_slot_id INT,
    FOREIGN KEY (teacher_id) REFERENCES staff(id) ON DELETE SET NULL,
    FOREIGN KEY (time_slot_id) REFERENCES time_slots(id)
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

-- Substitutions table
CREATE TABLE substitutions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT,
    original_staff_id INT,
    substitute_staff_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason TEXT,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    FOREIGN KEY (original_staff_id) REFERENCES staff(id) ON DELETE CASCADE,
    FOREIGN KEY (substitute_staff_id) REFERENCES staff(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Insert time slots
INSERT INTO time_slots (start_time, end_time, slot_name) VALUES 
('13:00', '14:00', '1:00 PM - 2:00 PM'),
('14:00', '15:00', '2:00 PM - 3:00 PM'),
('15:00', '16:00', '3:00 PM - 4:00 PM'),
('15:30', '16:30', '3:30 PM - 4:30 PM'),
('17:30', '18:30', '5:30 PM - 6:30 PM');

-- Insert initial admin user
INSERT INTO users (username, password, role) VALUES ('admin', 'admin123', 'admin');

-- Insert sample staff users
INSERT INTO users (username, password, role) VALUES
('staff1', 'staff123', 'staff'),
('staff2', 'staff123', 'staff'),
('staff3', 'staff123', 'staff'),
('staff4', 'staff123', 'staff');

-- Insert sample staff details
INSERT INTO staff (user_id, name, department) VALUES
((SELECT id FROM users WHERE username = 'staff1'), 'John Doe', 'Computer Science'),
((SELECT id FROM users WHERE username = 'staff2'), 'Jane Smith', 'Electronics'),
((SELECT id FROM users WHERE username = 'staff3'), 'Robert Johnson', 'Information Technology'),
((SELECT id FROM users WHERE username = 'staff4'), 'Mary Williams', 'Computer Science');

-- Insert sample classes
INSERT INTO classes (name, subject, teacher_id, schedule, department, semester, section, day_of_week, time_slot_id) VALUES 
('CSE-A Programming', 'Programming', 
 (SELECT id FROM staff WHERE name = 'John Doe'), 
 'Monday and Wednesday 9:00 AM - 10:00 AM',
 'Computer Science', 1, 'A', 'Monday', 1),
('CSE-A Digital Electronics', 'Digital Electronics', 
 (SELECT id FROM staff WHERE name = 'Jane Smith'), 
 'Monday and Wednesday 10:00 AM - 11:00 AM',
 'Computer Science', 1, 'A', 'Monday', 2),
('CSE-A Database', 'Database Management', 
 (SELECT id FROM staff WHERE name = 'Robert Johnson'), 
 'Monday and Wednesday 11:15 AM - 12:15 PM',
 'Computer Science', 1, 'A', 'Monday', 4),
('CSE-A Web Dev', 'Web Development', 
 (SELECT id FROM staff WHERE name = 'Mary Williams'), 
 'Tuesday and Thursday 9:00 AM - 10:00 AM',
 'Computer Science', 1, 'A', 'Tuesday', 1);

-- Insert sample assignments
INSERT INTO assignments (staff_id, class_id, subject) VALUES
((SELECT id FROM staff WHERE name = 'John Doe'), 
 (SELECT id FROM classes WHERE name = 'CSE-A Programming'), 'Programming'),
((SELECT id FROM staff WHERE name = 'Jane Smith'), 
 (SELECT id FROM classes WHERE name = 'CSE-A Digital Electronics'), 'Digital Electronics'),
((SELECT id FROM staff WHERE name = 'Robert Johnson'), 
 (SELECT id FROM classes WHERE name = 'CSE-A Database'), 'Database Management'),
((SELECT id FROM staff WHERE name = 'Mary Williams'), 
 (SELECT id FROM classes WHERE name = 'CSE-A Web Dev'), 'Web Development');

-- Insert sample leave requests
INSERT INTO leave_requests (staff_id, start_date, end_date, reason, status) VALUES
((SELECT id FROM staff WHERE name = 'John Doe'), '2024-03-20', '2024-03-22', 'Personal work', 'pending'),
((SELECT id FROM staff WHERE name = 'Jane Smith'), '2024-03-25', '2024-03-26', 'Medical appointment', 'approved'),
((SELECT id FROM staff WHERE name = 'Robert Johnson'), '2024-03-15', '2024-03-15', 'Family function', 'rejected');

-- Insert sample substitutions
INSERT INTO substitutions (class_id, original_staff_id, substitute_staff_id, start_date, end_date, reason) VALUES
((SELECT id FROM classes WHERE name = 'CSE-A Programming'),
 (SELECT id FROM staff WHERE name = 'John Doe'),
 (SELECT id FROM staff WHERE name = 'Jane Smith'),
 '2024-03-20', '2024-03-22', 'Medical Leave'),
((SELECT id FROM classes WHERE name = 'CSE-A Digital Electronics'),
 (SELECT id FROM staff WHERE name = 'Jane Smith'),
 (SELECT id FROM staff WHERE name = 'Robert Johnson'),
 '2024-03-25', '2024-03-26', 'Conference Attendance');
